<?php

class fieldtype_input_datetime
{
  public $options;
  
  function __construct()
  {
    $this->options = array('title' => TEXT_FIELDTYPE_INPUT_DATETIME_TITLE);
  }
  
  function get_configuration()
  {
    $cfg = array();
    
    $cfg[] = array('title'=>TEXT_NOTIFY_WHEN_CHANGED, 'name'=>'notify_when_changed','type'=>'checkbox','tooltip_icon'=>TEXT_NOTIFY_WHEN_CHANGED_TIP);
    
    $cfg[] = array('title'=>TEXT_DATE_BACKGROUND, 
                   'name'=>'background',
                   'type'=>'colorpicker',                   
                   'tooltip'=>TEXT_DATE_BACKGROUND_TOOLTIP);
    
    $cfg[] = array('title'=>TEXT_DAYS_BEFORE_DATE, 
                   'name'=>'day_before_date',
                   'type'=>'input-with-colorpicker',                   
                   'tooltip'=>TEXT_DAYS_BEFORE_DATE_TIP);
    
    $cfg[] = array('title'=>TEXT_HIDE_FIELD_IF_EMPTY, 'name'=>'hide_field_if_empty','type'=>'checkbox','tooltip_icon'=>TEXT_HIDE_FIELD_IF_EMPTY_TIP);
    
    $cfg[] = array('title'=>TEXT_DATE_FORMAT, 'name'=>'date_format','type'=>'input','tooltip'=>TEXT_DEFAULT .': ' . CFG_APP_DATETIME_FORMAT . ', ' . TEXT_DATE_FORMAT_IFNO, 'params'=>array('class'=>'form-control input-small'));
                                  
    return $cfg;
  }
    
  function render($field,$obj,$params = array())
  {
    if(strlen($obj['field_' . $field['id']])>0 and $obj['field_' . $field['id']]!=0)
    {
      $value = date('Y-m-d H:i',$obj['field_' . $field['id']]);
    }
    else
    {
      $value = '';
    }
    
    return '
      <div class="input-group input-medium date datetimepicker-field">' . 
        input_tag('fields[' . $field['id'] . ']',$value,array('class'=>'form-control fieldtype_input_datetime field_' . $field['id'] . ($field['is_required']==1 ? ' required':''))) . 
        '<span class="input-group-btn">
          <button class="btn btn-default date-set" type="button"><i class="fa fa-calendar"></i></button>
        </span>
      </div>';
  }
  
  function process($options)
  {
    global $app_changed_fields;
  	
  	$value = (int)get_date_timestamp($options['value']);
  	
  	if(!$options['is_new_item'])
  	{
  		$cfg = new fields_types_cfg($options['field']['configuration']);
  	
  		if($value!=$options['current_field_value'] and $cfg->get('notify_when_changed')==1)
  		{
  			$app_changed_fields[] = array(
  					'name'=>$options['field']['name'],
  					'value'=>format_date_time($value),
  					'fields_id'=>$options['field']['id'],
  					'fields_value'=>$value
  			);
  		}
  	}
  	
    return $value;
  }
    
  function output($options)
  {
    if(isset($options['is_export']) and strlen($options['value'])>0 and $options['value']!=0)
    {
      return format_date_time($options['value']);
    }
    elseif(strlen($options['value'])>0 and $options['value']!=0)
    {
      $cfg = new fields_types_cfg($options['field']['configuration']);
      
      //highlight field if overdue date
      if($options['value']<time() and strlen($cfg->get('background'))>0)
      {                        
        return render_bg_color_block($cfg->get('background'),format_date_time($options['value'],$cfg->get('date_format')));
      }
      
      //highlight field before due date
      if(strlen($cfg->get('day_before_date'))>0 and strlen($cfg->get('day_before_date_color'))>0 and $options['value']>time())
      {
        if($options['value']<strtotime('+'.$cfg->get('day_before_date') . ' day'))
        {
          return render_bg_color_block($cfg->get('day_before_date_color'),format_date_time($options['value'],$cfg->get('date_format'))); 
        }
      }
              
      //return single value                                             
      return format_date_time($options['value'],$cfg->get('date_format'));              
    }
    else
    {
      return '';
    }
  }
    
  
  function reports_query($options)
  {
    $filters = $options['filters'];
    $sql_query = $options['sql_query'];
  
    $sql = reports::prepare_dates_sql_filters($filters);
        
    if(count($sql)>0)
    {
      $sql_query[] =  implode(' and ', $sql);
    }
              
    return $sql_query;
  }  
}