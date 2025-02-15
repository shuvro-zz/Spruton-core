<?php

if((!IS_AJAX or !isset($_GET['form_type'])) and $app_module_action!='preview_image')
{
	exit();
}	

//check if field exist
$field_query = db_query("select * from app_fields where id='" . _get::int('field_id') . "' and type='fieldtype_entity_multilevel'");
if(!$field = db_fetch_array($field_query))
{
	exit();
}

$cfg = new fields_types_cfg($field['configuration']);


$entities_levels = array_reverse(entities::get_parents($cfg->get('entity_id')));
$entities_levels[] = $cfg->get('entity_id');

//check entity access;
if(!in_array(_get::int('entity_id'),$entities_levels))
{
	exit();
}	

//check access
switch($_GET['form_type'])
{
	case 'ext/public/form':
		$check_query = db_query("select id from app_ext_public_forms where entities_id='" . $field['entities_id'] . "' and not find_in_set('" .  $field['id'] ."',hidden_fields)");
		if(!$check = db_fetch_array($check_query))
		{
			exit();
		}
		break;
	case 'users/registration':
		if($field['entities_id']!=1)
		{
			exit();
		}		
		break;
	default:
		if (!app_session_is_registered('app_logged_users_id'))
		{
			exit();
		}		
		break;
}

switch($app_module_action)
{
	case 'select_items':
				
		$parent_entity_item_id = _get::int('parent_entity_item_id');
		 				 
		$entity_info = db_find('app_entities',_get::int('entity_id'));
		$field_entity_info = db_find('app_entities',$field['entities_id']);
		 
		$choices = array();
		 
		 
		$listing_sql_query = 'e.id>0 ';
		$listing_sql_query_order = '';
		$listing_sql_query_join = '';
		$listing_sql_query_having = '';
		$listing_sql_select = '';
		 		
		//if parent entity is the same then select records from paretn items only
		if($parent_entity_item_id>0 and $entity_info['parent_id']>0)
		{						
			$listing_sql_query .= " and e.parent_item_id='" . db_input($parent_entity_item_id) . "'";
		}
		elseif($entity_info['parent_id']>0 and $parent_entity_item_id==0)
		{
			echo json_encode(['results'=>[]]);
			exit();
		}								
		
		if(isset($_GET['search']))
		{
			$items_search = new items_search($entity_info['id']);
			$items_search->set_search_keywords($_GET['search']);
			
			if(is_array($cfg->get('fields_for_search')))
			{
				$search_fields = [];
				foreach($cfg->get('fields_for_search') as $id)
				{
					$search_fields[] = ['id'=>$id];
				}
				$items_search->search_fields = $search_fields;
			}
			
			$listing_sql_query .= $items_search->build_search_sql_query('and');
		}
		 
		if($cfg->get('entity_id')==_get::int('entity_id'))
		{	
			$default_reports_query = db_query("select * from app_reports where entities_id='" . db_input($cfg->get('entity_id')). "' and reports_type='entityfield" . $field['id'] . "'");
			if($default_reports = db_fetch_array($default_reports_query))
			{							
				$listing_sql_query = reports::add_filters_query($default_reports['id'],$listing_sql_query);
				 
				//prepare having query for formula fields
				if(isset($sql_query_having[$entity_info['id']]))
				{
					$listing_sql_query_having  = reports::prepare_filters_having_query($sql_query_having[$entity_info['id']]);
				}
				 
				$info = reports::add_order_query($default_reports['listing_order_fields'],$entity_info['id']);
				$listing_sql_query_order .= $info['listing_sql_query'];
				$listing_sql_query_join .= $info['listing_sql_query_join'];
				 
			}
			else
			{
				$listing_sql_query_order .= " order by e.id";
			}	
		
		
		
			//prepare formula query
			if(strlen($heading_template = $cfg->get('heading_template')))
			{	
				if(preg_match_all('/\[(\d+)\]/',$heading_template,$matches))
				{					
					$listing_sql_select = fieldtype_formula::prepare_query_select($entity_info['id'], '',false,array('fields_in_listing'=>implode(',',$matches[1])));
				}
			}
		}
		
		$results = [];
		$listing_sql = "select  e.* " . $listing_sql_select . " from app_entity_" . $entity_info['id'] . " e "  . $listing_sql_query_join . " where " . $listing_sql_query . $listing_sql_query_having . $listing_sql_query_order;
		
		$listing_split = new split_page($listing_sql,'','query_num_rows', 30);
		$items_query = db_query($listing_split->sql_query, false);
		while($item = db_fetch_array($items_query))
		{
			
			$get_html = ($cfg->get('entity_id')==_get::int('entity_id') ? true:false);
			
			$template = fieldtype_entity_multilevel::render_heading_template($item, $entity_info, $field_entity_info, $cfg, $get_html);
			
			$results[] = ['id'=>$item['id'],'text'=>$template['text'],'html'=>$template['html']];
		}
		
		$response = ['results'=>$results];
		
		if($listing_split->number_of_pages!=$_GET['page'] and $listing_split->number_of_pages>0)
		{
			$response['pagination']['more'] = 'true';
		}
		
		echo json_encode($response);
		
		exit();
		
		break;
	
	case 'preview_image':
		$file = attachments::parse_filename(base64_decode($_GET['file']));
		
		$size = getimagesize($file['file_path']);
		header("Content-type: " . $size['mime']);
		header('Content-Disposition: filename="' . $file['name'] . '"');
		
		flush();
		
		readfile($file['file_path']);
		
		break;
		
	case 'copy_values':
		
		if(!strlen($cfg->get('copy_values'))) exit();
		
		$copy_values = [];
		foreach(preg_split('/\r\n|\r|\n/',$cfg->get('copy_values')) as $values)
		{
			if(!strstr($values,'=')) continue;
			
			$values = explode('=',str_replace(array(' ','[',']'),'',$values));
									
			$copy_values[] = [
					'from'=>(in_array($values[0],['id','date_added','created_by']) ? $values[0] : (int)$values[0]),
					'to'=>(int)$values[1]					
			];
		}
		
		$item_id = _post::int('item_id');
		$entity_id = $cfg->get('entity_id');
		
		$js = '';
		$item_query = db_query("select e.* " . fieldtype_formula::prepare_query_select($entity_id, '') . " from app_entity_" . $entity_id . " e where id='" . $item_id . "'");
		if($item = db_fetch_array($item_query))
		{
			foreach($copy_values as $value)
			{				
								
				if(in_array($value['from'],['id','date_added','created_by']))
				{	
					$item_value = $item[$value['from']];
				}
				else
				{
					if(!isset($item['field_' . $value['from']])) continue;
					
					$item_value = $item['field_' . $value['from']];
				}
				
				switch($app_fields_cache[$field['entities_id']][$value['to']]['type'])
				{
					case 'fieldtype_input_date':
						$item_value = ($item_value>0 ? date('Y-m-d',$item_value) : '');
						break;
					case 'fieldtype_input_datetime':
						$item_value = ($item_value>0 ? date('Y-m-d H:i',$item_value) : '');
						break;
				}
				
				switch($app_fields_cache[$field['entities_id']][$value['to']]['type'])
				{
					case 'fieldtype_users':
					case 'fieldtype_entity':
					case 'fieldtype_dropdown_multiple':
						$js .= '$("#fields_' . $value['to'] . '").val("' . addslashes($item_value). '".split(",")).trigger("chosen:updated");' . "\n";
						break;
					case 'fieldtype_tags':
						$js .= '$("#fields_' . $value['to'] . '").val("' . addslashes($item_value). '".split(",")).trigger("change");' . "\n";
						break;
					case 'fieldtype_checkboxes':
						$js .= '
								
								$(".field_' . $value['to'] . '").each(function(){      
							    $(this).attr("checked",false)
							    $("#uniform-"+$(this).attr("id")+" span").removeClass("checked")
										
									if($.inArray($(this).val(),"' . addslashes($item_value). '".split(","))!=-1)
									{
										$(this).attr("checked",true)
							    	$("#uniform-"+$(this).attr("id")+" span").addClass("checked")
									}
							  })								
								' . "\n";
						break;
					default:
						$js .= '$("#fields_' . $value['to'] . '").val("' . addslashes($item_value). '").trigger("chosen:updated");' . "\n";
						break;
				}
				
				
			}		
		}
		
		echo '<script>' . $js . '</script>';
		
		exit();
		break;
}