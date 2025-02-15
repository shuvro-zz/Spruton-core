<?php

if(!users::has_access('import') or !strlen($app_path))
{
	redirect_to('dashboard/access_forbidden');
}

$worksheet = array();

if(strlen($filename = $_FILES['filename']['name'])>0)
{       
  //rename file (issue with HTML.php:495 if file have UTF symbols)
  $filename  = 'import_data.' . (strstr($filename,'.xls') ?  'xls' : 'xlsx');
                        
  if(move_uploaded_file($_FILES['filename']['tmp_name'], DIR_WS_UPLOADS  . $filename))
  {                                
    require('includes/libs/PHPExcel/PHPExcel/IOFactory.php');
                
    $objPHPExcel = PHPExcel_IOFactory::load(DIR_WS_UPLOADS  . $filename);
                    
    unlink(DIR_WS_UPLOADS  . $filename);
    
    $objWorksheet = $objPHPExcel->getActiveSheet();

    $highestRow = $objWorksheet->getHighestRow(); // e.g. 10
    $highestColumn = $objWorksheet->getHighestColumn(); // e.g 'F'
    
    $highestColumnIndex = PHPExcel_Cell::columnIndexFromString($highestColumn); // e.g. 5
                
    for ($row = 1; $row <= $highestRow; ++$row) 
    {    
      $is_empty_row = true;  
      $worksheet_cols = array();
          
      for ($col = 0; $col <= $highestColumnIndex; ++$col) 
      {        
        $value = trim($objWorksheet->getCellByColumnAndRow($col, $row)->getValue());  
        $worksheet_cols[$col] = $value;
        
        if(strlen($value)>0) $is_empty_row = false;
      } 
                  
      if(!$is_empty_row)
      {
        $worksheet[] = $worksheet_cols;
      }       
    }    
  }
  else
  {
    $alerts->add(TEXT_FILE_NOT_LOADED,'warning');
    redirect_to('items/items','path=' . $app_path);
  }                           
}

if(isset($_POST['import_template']))
{
	if($_POST['import_template']>0)
	{
		$templates_query = db_query("select * from app_ext_import_templates where id='" . (int)$_POST['import_template']. "'");
		if($templates = db_fetch_array($templates_query))
		{
			$import_fields_list = (strlen($templates['import_fields']) ? json_decode($templates['import_fields']):[]);
			foreach($import_fields_list as $k=>$v)
			{
				if($v>0)
				{
					$import_fields[$k] = $v;
				}
			}
		}
	}
}
