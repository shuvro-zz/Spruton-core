<?php

class fieldtype_image
{
  public $options;
  
  function __construct()
  {
    $this->options = array('title' => TEXT_FIELDTYPE_IMAGE_TITLE);
  }
  
  function get_configuration()
  {
    $cfg = array();
    $cfg[] = array('title'=>TEXT_ALLOW_SEARCH, 'name'=>'allow_search','type'=>'checkbox','tooltip_icon'=>TEXT_ALLOW_SEARCH_TIP);
    $cfg[] = array('title'=>TEXT_PREVIEW_IMAGE_SIZE, 'name'=>'width','type'=>'input','tooltip_icon'=>TEXT_PREVIEW_IMAGE_SIZE_TIP,'params'=>array('class'=>'form-control input-small'));
    $cfg[] = array('title'=>TEXT_PREVIEW_IMAGE_SIZE_IN_LISTING, 'name'=>'width_in_listing','type'=>'input','params'=>array('class'=>'form-control input-small'));
    $cfg[] = array('title'=>TEXT_ALLOWED_EXTENSIONS, 'name'=>'allowed_extensions','type'=>'input','tooltip_icon'=>TEXT_ALLOWED_EXTENSIONS_TIP,'params'=>array('class'=>'form-control input-large'));
        
    return $cfg;
  }  
    
  function render($field,$obj,$params = array())
  {
    $filename = $obj['field_' . $field['id']];
    $html = '';
    if(strlen($filename)>0)
    {
      $file = attachments::parse_filename($filename);
      $html = '
        <div>' .  $file['name'] . input_hidden_tag('files[' . $field['id'] . ']',$filename) . '</div>
        ' . (users::has_access('delete') ? '<div><label class="checkbox">' . input_checkbox_tag('delete_files[' . $field['id'] . ']',1) . ' ' . TEXT_DELETE . '</label></div>':'');
    }
    
    $cfg = new fields_types_cfg($field['configuration']);
        
   return input_file_tag('fields[' . $field['id'] . ']',fieldtype_attachments::get_accept_types($cfg)+array('class'=>'btn btn-default fieldtype_image field_' . $field['id'] . (($field['is_required']==1 and !strlen($filename)) ? ' required':''))) . $html;   
   
  }
  
  function process($options)
  {    
    global $alerts;
          
    $field_id = $options['field']['id'];  
    
    if(isset($_POST['delete_files'][$field_id]))
    {
      $file = attachments::parse_filename($_POST['files'][$field_id]);
      if(is_file(DIR_WS_ATTACHMENTS . $file['folder'] .'/'. $file['file_sha1']))
      {
        unlink(DIR_WS_ATTACHMENTS . $file['folder']  .'/' . $file['file_sha1']);
      }
      
      return '';
    }
    
    
    if(strlen($_FILES['fields']['name'][$field_id])>0)
    {     
      $file = attachments::prepare_filename($_FILES['fields']['name'][$field_id]);
                          
      if(move_uploaded_file($_FILES['fields']['tmp_name'][$field_id], DIR_WS_ATTACHMENTS  . $file['folder']  .'/'. $file['file']))
      {          
      	//autoresize images if enabled
      	attachments::resize(DIR_WS_ATTACHMENTS  . $file['folder']  .'/'. $file['file']);
      	
        return $file['name'];
      }
      else
      {
        return '';
      }                         
    }
    elseif(isset($_POST['files'][$field_id]))
    {
      return $_POST['files'][$field_id];
    }
    else
    {
      return '';
    }    
  }
  
  function output($options)
  {
    
    if(strlen($options['value'])>0)
    {  
      $file = attachments::parse_filename($options['value']);
            
      if(isset($options['is_print']))
      {
      	return '<img width=120 height=120 src=' . url_for('items/info&path=' . $options['field']['entities_id']  ,'&action=download_attachment&preview=1&file=' . urlencode(base64_encode($options['value']))) . '>';
      }
      elseif(isset($options['is_export']))
      {
        return $file['name'];    
      }
      else
      {  
        if($file['is_image'])
        {              
          $cfg = new fields_types_cfg($options['field']['configuration']);
                     
          $fancybox_css_class = 'fancybox' . time();
                   
          $img = '<img class="fieldtype_image field_' . $options['field']['id'] . '"   src="' . url_for('items/info&path=' . $options['path']  ,'&action=download_attachment&preview=1&file=' . urlencode(base64_encode($options['value']))) . '">';                    
          
          $width = (isset($options['is_listing']) ? (strlen($cfg->get('width_in_listing')) ? $cfg->get('width_in_listing'):250) : (strlen($cfg->get('width')) ? $cfg->get('width') : 250));
          
          $html = '
          <div class="fieldtype-image-container" style="width: ' . $width . 'px; max-height: ' . $width . 'px;">' . 
            link_to($img,url_for('items/info&path=' . $options['path'] ,'&action=preview_attachment_image&file=' . urlencode(base64_encode($options['value']))),array('class'=>$fancybox_css_class)) . '
           </div> 
          '; 
          
          if(!isset($options['is_listing']))
          {
          	$html .= '
          	<div class="fieldtype-image-filename" style="width: ' . $width . 'px">
              ' . link_to('<i class="fa fa-download"></i> ' . $file['name'],url_for('items/info','path=' . $options['path'] . '&action=download_attachment&file=' . urlencode(base64_encode($options['value'])))) . '
            </div>';
          }
          
          $html .='
          <script>
            $(document).ready(function() {
            	$(".' . $fancybox_css_class . '").fancybox({type: "ajax"});
            });
          </script>
          ';
          
          return $html; 
        } 
        else
        {
          return '<img src="' . $file['icon'] . '"> ' . link_to($file['name'],url_for('items/info','path=' . $options['path'] . '&action=download_attachment&file=' . urlencode(base64_encode($options['value']))),array('target'=>'_blank')) . '  <small>(' . $file['size']. ')</small>';
        }              
      }
    }
    else
    {
      return '';
    }
  }
  
  
}