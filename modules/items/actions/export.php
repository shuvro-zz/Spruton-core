<?php

if(!users::has_access('export_selected'))
{
	redirect_to('dashboard/access_forbidden');
}


switch($app_module_action)
{ 
	case 'delete_templates':
				db_delete_row('app_items_export_templates',$_POST['id']);
			exit();
		break;
	case 'set_default_templates':
			//reset defaults for current entity
			db_query("update app_items_export_templates set is_default=0 where users_id='" . db_input($app_user['id']) . "' and entities_id='" . db_input($current_entity_id) . "'");
			//set default for current row
			db_query("update app_items_export_templates set is_default=1 where users_id='" . db_input($app_user['id']) . "' and id='" . $_POST['id'] . "'");
			exit();
		break;
	case 'get_default_templates':
			$templates_info_query = db_query("select * from app_items_export_templates where entities_id='" . db_input($current_entity_id) . "' and users_id='" . db_input($app_user['id']) . "' and is_default=1");
			if($templates_info = db_fetch_array($templates_info_query))
			{
				echo app_json_encode(array($templates_info['templates_fields'],$templates_info['id'],$templates_info['name']));
			}
			
			exit();
		break;
	case 'update_templates_fields':
			$sql_data_array = array(			
					'templates_fields' =>$_POST['fields_list'],			
			);
			
			db_perform('app_items_export_templates', $sql_data_array,'update',"users_id='" . db_input($app_user['id']) . "' and id='" . $_POST['id'] . "'");
			
			exit();
		break;
	case 'update_templates_name':
			$sql_data_array = array(
				'name' =>db_prepare_input($_POST['name']),
			);
				
			db_perform('app_items_export_templates', $sql_data_array,'update',"users_id='" . db_input($app_user['id']) . "' and id='" . $_POST['id'] . "'");
				
			exit();
			break;
	case 'save_templates':
				$templates_name = db_prepare_input($_POST['templates_name']);
				$export_fields_list = db_prepare_input($_POST['export_fields_list']);
				
				$check_query = db_query("select count(*) as total from app_items_export_templates where entities_id='" . db_input($current_entity_id) . "' and users_id='" . db_input($app_user['id']) . "' and name='" . db_input($templates_name) . "'");
				$check = db_fetch_array($check_query);
				
				$count_query = db_query("select count(*) as total from app_items_export_templates where entities_id='" . db_input($current_entity_id) . "' and users_id='" . db_input($app_user['id']) . "'");
				$count = db_fetch_array($count_query);
											
				if($check['total']==0)
				{
					$sql_data_array = array(
							'name' => $templates_name,
							'templates_fields' =>$export_fields_list,
							'entities_id' => $current_entity_id,
							'users_id' => $app_user['id'],
							'is_default' => ($count['total']==0 ? 1:0)
					);
					
					db_perform('app_items_export_templates', $sql_data_array);
				}
				else
				{
					echo sprintf(TEXT_TEMPLATE_ALREADY_EXIST,$templates_name);
				}
			exit();			
		break;	
	case 'get_templates_button':
		
			$html = '';
			$html_list = '';
			
			$check_query = db_query("select count(*) as total from app_items_export_templates where entities_id='" . db_input($current_entity_id) . "' and users_id='" . db_input($app_user['id']) . "'");
			$check = db_fetch_array($check_query);
			if($check['total']>0)
			{
				$html_list = '';
				$templates_query = db_query("select * from app_items_export_templates where entities_id='" . db_input($current_entity_id) . "' and users_id='" . db_input($app_user['id']) . "'");
				while($templates = db_fetch_array($templates_query))
				{
					$html_list .= '<li><a href="javascript: use_items_export_template(\'' . $templates['templates_fields'] . '\',' . $templates['id'] . ',\'' . addslashes($templates['name']). '\')">' . $templates['name'] . '</a></li>';					
				}
			}
			else 
			{
				$html_list .= '<li><a href="#"><i>' . TEXT_NO_RECORDS_FOUND . '</i></a></li>';
			}
			
			$html_list .= '<li class="divider"></li><li><a href="javascript: open_my_templates_tab()">' . TEXT_ADD_NEW_TEMPLATE . '</a></li>';
			
				
			$html = '
			<div class="btn-group">
				<button class="btn btn-info dropdown-toggle" type="button" data-toggle="dropdown" data-hover="dropdown">' . TEXT_SELECT_TEMPLATE . ' <i class="fa fa-angle-down"></i></button>
				<ul class="dropdown-menu" role="menu">
					' . $html_list . '
				</ul>
			</div>
			
			<script>
				$(\'[data-hover="dropdown"]\').dropdownHover();
			</script>				
		  ';
								
			echo $html;
			
			exit();
		break;
	case 'get_templates':

		
		$html = '
				<table class="table">
					<tr>
							<th>' . TEXT_NAME . '</th>							
							<th style="text-align: center;">' . TEXT_IS_DEFAULT . '</th>
							<th></th>
					</tr>';
		 
			$check_query = db_query("select count(*) as total from app_items_export_templates where entities_id='" . db_input($current_entity_id) . "' and users_id='" . db_input($app_user['id']) . "'");
			$check = db_fetch_array($check_query);
			if($check['total']>0)
			{
				$templates_query = db_query("select * from app_items_export_templates where entities_id='" . db_input($current_entity_id) . "' and users_id='" . db_input($app_user['id']) . "'");
				while($templates = db_fetch_array($templates_query))
				{
					$html .= '
						<tr class="templates-row-' . $templates['id'] . '">
							<td style="padding-right: 15px;">' . input_tag('export_template_name[]',$templates['name'],array('class'=>'form-control','onKeyUp'=>'update_items_export_templates_name(' . $templates['id'] . ',this.value)')) . '</td>							
							<td align="center">' . input_radiobox_tag('is_default_template',1, array('checked'=>$templates['is_default'],'data-id'=>$templates['id'])) . '</td>
							<td><button onClick="delete_items_export_templates(' . $templates['id'] . ')" class="btn btn-default" type="button"><i class="fa fa-trash-o" title="' . addslashes(TEXT_BUTTON_DELETE). '"></i></button></td>
						</tr>
					';
				}
			}
			else
			{
				$html .= '
					<tr>
						<td colspan="4">' . TEXT_NO_RECORDS_FOUND . '</td>
					</tr>
				';
			}
			
			$html .= '</table>'; 
					 
			echo $html;
			
			exit();
		break;
		
	case 'print':
			
		
		if(!isset($app_selected_items[$_POST['reports_id']])) $app_selected_items[$_POST['reports_id']] = array();
		
		if(count($app_selected_items[$_POST['reports_id']])>0 and isset($_POST['fields']))
		{
			$current_entity_info = db_find('app_entities',$current_entity_id);
		
			$listing_fields = array();
			$export = '					
					<table class="table table-bordered" style="width: auto">
						<thead>
					';
			$heading = array();
		
			//adding reserved fields
			$fields_query = db_query("select f.*, t.name as tab_name from app_fields f, app_forms_tabs t where f.type not in ('fieldtype_action') and f.id in (" . implode(',',$_POST['fields']). ") and f.entities_id='" . db_input($current_entity_id) . "' and f.forms_tabs_id=t.id order by t.sort_order, t.name, f.sort_order, f.name");
			while($fields = db_fetch_array($fields_query))
			{
				if($fields['type']=='fieldtype_dropdown_multilevel')
				{
					$export .= fieldtype_dropdown_multilevel::output_listing_heading($fields);
				}
				else
				{
					$export .= '<th><div>' . fields_types::get_option($fields['type'],'name',$fields['name']) . '</div></th>';
				}
		
				$listing_fields[] = $fields;
			}
		
			//adding item url
			if(isset($_POST['export_url']))
			{
				$export .= '<th><div>' . TEXT_URL_HEADING . '</div></th>';
			}
		
			$export .= '
				    </tr>
				  </thead>
				  <tbody>        
				';
			
			//echo $export;
			//exit();
		
			$selected_items = implode(',',$app_selected_items[$_POST['reports_id']]);
		
			//prepare forumulas query
			$listing_sql_query_select = fieldtype_formula::prepare_query_select($current_entity_id, '',false,array('fields_in_listing'=>implode(',',$_POST['fields'])));
		
			$listing_sql = "select e.* " . $listing_sql_query_select . " from app_entity_" . $current_entity_id . " e where e.id in (" . $selected_items . ") order by field(id," . $selected_items . ")" ;
			$items_query = db_query($listing_sql);
			while($item = db_fetch_array($items_query))
			{
				$export .= '<tr>';
				$row = array();
		
				$path_info_in_report = array();
		
				if($current_entity_info['parent_id']>0)
				{
					$path_info_in_report = items::get_path_info($current_entity_id,$item['id']);
					 
				}
		
				foreach($listing_fields as $field)
				{
							
					$value = items::prepare_field_value_by_type($field, $item);
			
					$output_options = array('class'=>$field['type'],
							'value'=>$value,
							'field'=>$field,
							'item'=>$item,
							'is_export'  => true,
							'is_print'  => true,
							'reports_id'=> $_POST['reports_id'],
							'path'=> (isset($path_info_in_report['full_path']) ? $path_info_in_report['full_path']  :$current_path),
							'path_info'   => $path_info_in_report);
				
					$export .= '
							<td>' . fields_types::output($output_options) . '</td>
							';
					
				}
		
				if(isset($_POST['export_url']))
				{
					$export .= '
							<td>' .  url_for('items/info', 'path=' . (isset($path_info_in_report['full_path']) ? $path_info_in_report['full_path']  :$current_path . '-' . $item['id'])) . '</td>
							';
				}	
				
				$export .= '</tr>';				
			}
			
			$export .= '
			  </tbody>';
												
			$export .= '
			    </table>					
					';
		
			//echo '<pre>';
			//print_r($export);
			
			$html = '
			<!DOCTYPE html>		
      <html lang=' . APP_LANGUAGE_SHORT_CODE  .'" dir="' . APP_LANGUAGE_TEXT_DIRECTION  . '">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			
            <link href="template/plugins/font-awesome/css/font-awesome.min.css?v=4.7.0" rel="stylesheet" type="text/css"/>
						<link href="template/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
						<link href="template/css/style-conquer.css?v=2" rel="stylesheet" type="text/css"/>
						<link href="template/css/style.css?v=2" rel="stylesheet" type="text/css"/>
						<link href="template/css/style-responsive.css?v=2" rel="stylesheet" type="text/css"/>
						<link href="template/css/plugins.css" rel="stylesheet" type="text/css"/>
						<link rel="stylesheet" type="text/css" href="css/default.css?v=' . PROJECT_VERSION . '"/>
						<script src="template/plugins/jquery-1.10.2.min.js" type="text/javascript"></script>		
											
        </head>
        <body>
				' . $export . '
				<script src="template/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
				<script>
            window.print();
        </script>		
        </body>
      </html>
      ';
			
			echo $html;
			
			
		}
		
			exit();
		break;
		
		
  case 'export':
      if(!isset($app_selected_items[$_POST['reports_id']])) $app_selected_items[$_POST['reports_id']] = array();
      
      if(count($app_selected_items[$_POST['reports_id']])>0 and isset($_POST['fields']))
      {    
        $current_entity_info = db_find('app_entities',$current_entity_id);
        
        $listing_fields = array();
        $export = array();
        $heading = array();
                        
        //adding reserved fields               
        $fields_query = db_query("select f.*, t.name as tab_name from app_fields f, app_forms_tabs t where f.type not in ('fieldtype_action') and f.id in (" . implode(',',$_POST['fields']). ") and f.entities_id='" . db_input($current_entity_id) . "' and f.forms_tabs_id=t.id order by t.sort_order, t.name, f.sort_order, f.name");
        while($fields = db_fetch_array($fields_query))
        {
        	if($fields['type']=='fieldtype_dropdown_multilevel')
        	{
        		$heading = array_merge($heading,fieldtype_dropdown_multilevel::output_listing_heading($fields,true));
        	}
        	else
        	{
          	$heading[] = fields_types::get_option($fields['type'],'name',$fields['name']);
        	}
          
          $listing_fields[] = $fields;
        } 
                                      
        //adding item url
        if(isset($_POST['export_url']))
        {
        	$heading[] = TEXT_URL_HEADING;
        }
        
        $export[] = $heading;
        
        $selected_items = implode(',',$app_selected_items[$_POST['reports_id']]);
        
        //prepare forumulas query
        $listing_sql_query_select = fieldtype_formula::prepare_query_select($current_entity_id, '',false,array('fields_in_listing'=>implode(',',$_POST['fields'])));
        
        $listing_sql = "select e.* " . $listing_sql_query_select . " from app_entity_" . $current_entity_id . " e where e.id in (" . $selected_items . ") order by field(id," . $selected_items . ")" ;        
        $items_query = db_query($listing_sql);
        while($item = db_fetch_array($items_query))
        {
          $row = array();
          
          $path_info_in_report = array();
          
          if($current_entity_info['parent_id']>0)
          {
            $path_info_in_report = items::get_path_info($current_entity_id,$item['id']);
                               
          }                      
          
          foreach($listing_fields as $field)
          {
                                           
            //prepare field value
            $value = items::prepare_field_value_by_type($field, $item);
                        
            $output_options = array('class'=>$field['type'],
                                    'value'=>$value,
                                    'field'=>$field,
                                    'item'=>$item,
                                    'is_export'=>true,                                    
                                    'reports_id'=> $_POST['reports_id'],
                                    'path'=> (isset($path_info_in_report['full_path']) ? $path_info_in_report['full_path']  :$current_path),
            												'path_info'   => $path_info_in_report);
            
            if($field['type']=='fieldtype_dropdown_multilevel')
            {
            	$row = array_merge($row,fieldtype_dropdown_multilevel::output_listing($output_options,true));
            }
            else
            {    
            	if(in_array($field['type'],array('fieldtype_textarea_wysiwyg','fieldtype_textarea')))
            	{
            		$row[] = trim(fields_types::output($output_options));
            	}
            	else
            	{
            		$row[] = trim(strip_tags(fields_types::output($output_options)));
            	}
            	
            }
          }    
          
          if(isset($_POST['export_url']))
          {          	                                       
          	$row[] = url_for('items/info', 'path=' . (isset($path_info_in_report['full_path']) ? $path_info_in_report['full_path']  :$current_path . '-' . $item['id']));
          }
          
          $export[] = $row;                                            
        } 
                
        //echo '<pre>';
        //print_r($export);
        //exit();
        
        $filename = str_replace(' ','_',trim($_POST['filename']));
                
        require('includes/libs/PHPExcel/PHPExcel.php');
        
        $objPHPExcel = new PHPExcel();
        
        $objPHPExcel->getProperties()->setCreator($app_user['name'])
							 ->setLastModifiedBy($app_user['name'])
							 ->setTitle($filename)
							 ->setSubject('')
							 ->setDescription('')
							 ->setKeywords('')
							 ->setCategory('');
               
        $objPHPExcel->getActiveSheet()->fromArray($export, null, 'A1');
      
        $objWorksheet = $objPHPExcel->getActiveSheet();;
        
        $highest_column = $objWorksheet->getHighestColumn();
        
        for ($col = 'A'; $col != $highest_column; $col++) 
        {
  	       $objPHPExcel->getActiveSheet()->getColumnDimension($col)->setAutoSize(true);
           $objPHPExcel->getActiveSheet()->getStyle($col.'1')->getFont()->setBold(true);
        }                                                                              
        
        $objPHPExcel->getActiveSheet()->getColumnDimension($highest_column)->setAutoSize(true);
        $objPHPExcel->getActiveSheet()->getStyle($highest_column.'1')->getFont()->setBold(true);
                        
        // Rename worksheet
        $objPHPExcel->getActiveSheet()->setTitle($filename);
                        
        // Redirect output to a client’s web browser (Excel2007)
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment;filename="' . addslashes($filename) . '.xlsx"');
        header('Cache-Control: max-age=0');
        // If you're serving to IE 9, then the following may be needed
        header('Cache-Control: max-age=1');
        
        // If you're serving to IE over SSL, then the following may be needed
        header ('Expires: Mon, 26 Jul 1997 05:00:00 GMT'); // Date in the past
        header ('Last-Modified: '.gmdate('D, d M Y H:i:s').' GMT'); // always modified
        header ('Cache-Control: cache, must-revalidate'); // HTTP/1.1
        header ('Pragma: public'); // HTTP/1.0
        
        ob_clean();
        flush();
        
        
        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');        
        $objWriter->save('php://output');                       
      }
                  
    exit();
  break;
  
  case 'export_csv':
  	  	
  	if(!isset($app_selected_items[$_POST['reports_id']])) $app_selected_items[$_POST['reports_id']] = array();
  
  	if(count($app_selected_items[$_POST['reports_id']])>0 and isset($_POST['fields']))
  	{
  		$current_entity_info = db_find('app_entities',$current_entity_id);
  
  		$separator = "\t";
  		$listing_fields = array();
  		$export = array();
  		$heading = array();
  		
  		$filename = str_replace(' ','_',trim($_POST['filename']));
  		
  		$file_extension = $_POST['file_extension'];
  		
  		//start export
  		if($file_extension=='csv')
  		{
  			header("Content-type: Application/octet-stream");
  			header("Content-disposition: attachment; filename=" . $filename . ".csv");  			
  		}
  		else
  		{	
  			header("Content-type: text/plain");
  			header("Content-disposition: attachment; filename=" . $filename . ".txt");
  		}
  		
  		header("Pragma: no-cache");
  		header("Expires: 0");
  
  		//adding reserved fields
  		$fields_query = db_query("select f.*, t.name as tab_name from app_fields f, app_forms_tabs t where f.type not in ('fieldtype_action') and f.id in (" . implode(',',$_POST['fields']). ") and f.entities_id='" . db_input($current_entity_id) . "' and f.forms_tabs_id=t.id order by t.sort_order, t.name, f.sort_order, f.name");
  		while($fields = db_fetch_array($fields_query))
  		{
  			if($fields['type']=='fieldtype_dropdown_multilevel')
  			{
  				$heading = array_merge($heading,fieldtype_dropdown_multilevel::output_listing_heading($fields,true));
  			}
  			else
  			{
  				$heading[] = str_replace(array("\n\r","\r","\n",$separator),' ',fields_types::get_option($fields['type'],'name',$fields['name']));
  			}
  
  			$listing_fields[] = $fields;
  		}
  
  		//adding item url
  		if(isset($_POST['export_url']))
  		{
  			$heading[] = TEXT_URL_HEADING;
  		}
  
  		//outpout heading
  		$content = implode($separator,$heading) . "\n";
  		
  		if($file_extension=='csv')
  		{
  			echo chr( 0xFF ) . chr( 0xFE ) . mb_convert_encoding( $content, 'UTF-16LE', 'UTF-8' );
  		}
  		else
  		{
  			echo $content;
  		}
  
  		$selected_items = implode(',',$app_selected_items[$_POST['reports_id']]);
  
  		//prepare forumulas query
  		$listing_sql_query_select = fieldtype_formula::prepare_query_select($current_entity_id, '',false,array('fields_in_listing'=>implode(',',$_POST['fields'])));
  
  		$listing_sql = "select e.* " . $listing_sql_query_select . " from app_entity_" . $current_entity_id . " e where e.id in (" . $selected_items . ") order by field(id," . $selected_items . ")" ;
  		$items_query = db_query($listing_sql);
  		while($item = db_fetch_array($items_query))
  		{
  			$row = array();
  
  			$path_info_in_report = array();
  
  			if($current_entity_info['parent_id']>0)
  			{
  				$path_info_in_report = items::get_path_info($current_entity_id,$item['id']);
  				 
  			}
  
  			foreach($listing_fields as $field)
  			{
  
  				//prepare field value
          $value = items::prepare_field_value_by_type($field, $item);
  
  				$output_options = array('class'=>$field['type'],
  						'value'=>$value,
  						'field'=>$field,
  						'item'=>$item,
  						'is_export'=>true,
  						'reports_id'=> $_POST['reports_id'],
  						'path'=> (isset($path_info_in_report['full_path']) ? $path_info_in_report['full_path']  :$current_path),
  						'path_info'   => $path_info_in_report);
  
  				if($field['type']=='fieldtype_dropdown_multilevel')
  				{
  					$row = array_merge($row,fieldtype_dropdown_multilevel::output_listing($output_options,true));
  				}
  				else
  				{
  					if(in_array($field['type'],array('fieldtype_textarea_wysiwyg','fieldtype_textarea')))
  					{
  						$row[] = str_replace(array("\n\r","\r","\n",$separator),' ',trim(fields_types::output($output_options)));
  					}
  					else
  					{
  						$row[] = str_replace(array("\n\r","\r","\n",$separator),' ',trim(strip_tags(fields_types::output($output_options))));
  					}
  					 
  				}
  			}
  
  			if(isset($_POST['export_url']))
  			{
  				$row[] = url_for('items/info', 'path=' . (isset($path_info_in_report['full_path']) ? $path_info_in_report['full_path']  :$current_path . '-' . $item['id']));
  			}
  
  			//outpout row
	  		$content = implode($separator,$row) . "\n";
	  		if($file_extension=='csv')
	  		{
	  			echo chr( 0xFF ) . chr( 0xFE ) . mb_convert_encoding( $content, 'UTF-16LE', 'UTF-8' );
	  		}
	  		else
	  		{
	  			echo $content;
	  		}
  		}
  

  	}
  
  	exit();
  	break;  
}  