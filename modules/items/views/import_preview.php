
<?php 
	$app_breadcrumb[] = array('title'=>TEXT_IMPORT);
	require(component_path('items/navigation')) 
?>

<p><?php echo TEXT_IMPORT_BIND_FIELDS ?></p>

<?php

if($current_entity_id==1)
{
	echo '<div class="alert alert-info">' . TEXT_USERS_IMPORT_NOTE . '</div>';
}

//echo '<pre>';
//print_r($worksheet);
//echo '</pre>';
 
echo form_tag('import_data', url_for('items/import','action=import&path=' . $app_path)) . '<div id="worksheet_preview_container"> <table>';
for ($row = 0; $row < count($worksheet); ++$row) 
{
  
  if($row ==1)
  {
    echo '<tr><td></td>';

    for ($col = 0; $col <= count($worksheet[$row]); ++$col) 
    {
      echo '
				<td>' . link_to_modalbox(TEXT_BIND_FIELD,url_for('items/import_bind','col=' . $col . '&entities_id=' . $current_entity_id . '&path=' . $app_path)) . '
    			<div class="import_col" id="import_col_' . $col . '">' . (isset($import_fields[$col]) ? '<b>' . $app_fields_cache[$current_entity_id][$import_fields[$col]]['name'] . '</b>': '-') . '</div>
      	</td>';
    }
    
    echo '</tr>';
        
  }

  echo '<tr><td>' . $row . '</td>';

  for ($col = 0; $col <= count($worksheet[$row]); ++$col) 
  {
    if(isset($worksheet[$row][$col]))
    {
      echo '<td>' . $worksheet[$row][$col] . '</td>';
    }
    else
    {
      echo '<td></td>';
    }
  }
    
  echo '</tr>';
}
echo '</table>
  </div>
<p><label>' . input_checkbox_tag('import_first_row',1) . ' ' . TEXT_IMPORT_FIRST_ROW . '</label></p>';

//import users settings
if($current_entity_id==1)
{
	echo '
  	<p>' . TEXT_USERS_IMPORT_USERS_GROUP . ': ' . select_tag('users_group_id',access_groups::get_choices(),'',array('class'=>'form-control input-medium')) . '</p>
  	<p><label>' . input_checkbox_tag('set_pwd_as_username',1) . ' ' . TEXT_IMPORT_SET_PWD_AS_USERNAME . '</label></p>';	
}


//update settings
if($_POST['import_action']=='update' or $_POST['import_action']=='update_import')
{
	$choices = array(''=>'');
	$fields_query = db_query("select f.* from app_fields f where f.type in ('fieldtype_id','fieldtype_input','fieldtype_random_value') and f.entities_id='" . $current_entity_id . "'");		
	while($fields = db_fetch_array($fields_query))
	{
		$choices[$fields['id']] = fields_types::get_option($fields['type'],'name',$fields['name']);
	}
	
	$choices_col = array(''=>'');
	$row = 0;
	for ($col = 0; $col <= count($worksheet[$row]); ++$col)
	{
		if(isset($worksheet[$row][$col]))
		{
			$choices_col[$col] =  $worksheet[$row][$col];
		}		
	}
	
	echo '
		<h4>' . TEXT_UPDATE_SETTINGS . '</h4>	
  	<p>' . TEXT_UPDATE_BY_FIELD . ': ' . select_tag('update_by_field',$choices,'',array('class'=>'form-control input-medium required')) . '</p>
  	<p>' . TEXT_USE_COLUMN . ': ' . select_tag('update_use_column',$choices_col,'',array('class'=>'form-control input-medium required')) . '</p>';
}

echo  '<br>' . submit_tag(TEXT_BUTTON_IMPORT)  . ' ' . button_tag(TEXT_BUTTON_BACK,url_for('items/items','path=' . $app_path),false,array('class'=>'btn btn-default')) . 
    input_hidden_tag('worksheet',addslashes(json_encode($worksheet))) .     
    input_hidden_tag('import_action',$_POST['import_action']) . '  
</form>';
?>

<script>
	$(function(){
		$('#import_data').validate()
	})
		
  function bind_field(col)
  {
    $.post("<?php echo url_for('items/import','action=bind_field&path=' . $app_path) ?>", $("#bind_field_form").serialize()).success(function(data) { 
            
      if(data.trim()!='')
      {
        $('#import_col_'+col).html('<div class="binded_field_container" >'+data+'</div>');
      }
      else
      {
        $('#import_col_'+col).html('-');
      } 
    });   
       
    $('#ajax-modal').modal('hide');
    return false;
  }
</script>

