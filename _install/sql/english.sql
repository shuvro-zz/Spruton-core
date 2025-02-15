CREATE TABLE IF NOT EXISTS `app_access_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `is_default` tinyint(1) DEFAULT NULL,
  `is_ldap_default` tinyint(1) DEFAULT NULL,
  `ldap_filter` text NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

INSERT INTO app_access_groups VALUES
('4','Manager','1','0','','2'),
('5','Developer','0','0','','1'),
('6','Client','0','0','','0');

CREATE TABLE IF NOT EXISTS `app_access_rules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entities_id` int(10) unsigned NOT NULL,
  `fields_id` int(10) unsigned NOT NULL,
  `choices` text NOT NULL,
  `users_groups` text NOT NULL,
  `access_schema` text NOT NULL,
  `fields_view_only_access` text NOT NULL,
  `comments_access_schema` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_fields_id` (`fields_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_access_rules_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entities_id` int(10) unsigned NOT NULL,
  `fields_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_fields_id` (`fields_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_token` varchar(64) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `date_added` date NOT NULL,
  `container` varchar(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_backups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `filename` varchar(64) NOT NULL,
  `date_added` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_users_id` (`users_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_choices_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `items_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_fields_id` (`fields_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `items_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `description` text,
  `attachments` text NOT NULL,
  `date_added` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_created_by` (`created_by`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_comments_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `access_groups_id` int(11) NOT NULL,
  `access_schema` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_access_groups_id` (`access_groups_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

INSERT INTO app_comments_access VALUES
('4','21','6','view,create'),
('5','21','5','view,create'),
('6','21','4','view,create,update,delete'),
('7','22','5','view,create'),
('8','22','4','view,create,update,delete'),
('9','23','6','view,create'),
('10','23','4','view,create,update,delete'),
('11','24','5','view,create'),
('12','24','4','view,create,update,delete');

CREATE TABLE IF NOT EXISTS `app_comments_forms_tabs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_comments_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comments_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `fields_value` text,
  PRIMARY KEY (`id`),
  KEY `idx_comments_id` (`comments_id`),
  KEY `idx_fields_id` (`fields_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `configuration_name` varchar(255) NOT NULL DEFAULT '',
  `configuration_value` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_dashboard_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_by` int(11) NOT NULL,
  `sections_id` int(11) NOT NULL,
  `type` varchar(16) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `icon` varchar(64) NOT NULL,
  `description` text NOT NULL,
  `color` varchar(16) NOT NULL,
  `users_fields` text NOT NULL,
  `users_groups` text NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_sections_id` (`sections_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_dashboard_pages_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `grid` tinyint(1) NOT NULL,
  `sort_order` smallint(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_emails_on_schedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_added` int(11) NOT NULL,
  `email_to` varchar(255) NOT NULL,
  `email_to_name` varchar(255) NOT NULL,
  `email_subject` varchar(255) NOT NULL,
  `email_body` text NOT NULL,
  `email_from` varchar(255) NOT NULL,
  `email_from_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_entities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `notes` text NOT NULL,
  `display_in_menu` tinyint(1) DEFAULT '0',
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

INSERT INTO app_entities VALUES
('1','0','Users','','0','10'),
('21','0','Projects','','0','1'),
('22','21','Tasks','','0','1'),
('23','21','Tickets','','0','2'),
('24','21','Discussions','','0','3');

CREATE TABLE IF NOT EXISTS `app_entities_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `access_groups_id` int(11) NOT NULL,
  `access_schema` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_access_groups_id` (`access_groups_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

INSERT INTO app_entities_access VALUES
('28','21','6','view_assigned'),
('29','21','5','view_assigned,reports'),
('30','21','4','view,create,update,delete,reports'),
('31','22','6',''),
('32','22','5','view,create,update,reports'),
('33','22','4','view,create,update,delete,reports'),
('34','23','6','view_assigned,create,update,reports'),
('35','23','5',''),
('36','23','4','view,create,update,delete,reports'),
('37','24','6',''),
('38','24','5','view_assigned,create,update,delete,reports'),
('39','24','4','view,create,update,delete,reports');

CREATE TABLE IF NOT EXISTS `app_entities_configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `configuration_name` varchar(255) NOT NULL DEFAULT '',
  `configuration_value` text,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;

INSERT INTO app_entities_configuration VALUES
('11','1','menu_title','Users'),
('12','1','listing_heading','Users'),
('13','1','window_heading','User Info'),
('14','1','insert_button','Add User'),
('15','1','use_comments','0'),
('25','21','menu_title',' Projects'),
('26','21','listing_heading',' Projects'),
('27','21','window_heading','Project Info'),
('28','21','insert_button','Add Project'),
('29','21','email_subject_new_item','New Project:'),
('30','21','use_comments','1'),
('31','21','email_subject_new_comment','New project comment:'),
('32','22','menu_title','Tasks'),
('33','22','listing_heading','Tasks'),
('34','22','window_heading','Task Info'),
('35','22','insert_button','Add Task'),
('36','22','email_subject_new_item','New Task'),
('37','22','use_comments','1'),
('38','22','email_subject_new_comment','New task comment:'),
('39','23','menu_title','Tickets'),
('40','23','listing_heading','Tickets'),
('41','23','window_heading','Ticket Info'),
('42','23','insert_button','Add Ticket'),
('43','23','email_subject_new_item','New Ticket:'),
('44','23','use_comments','1'),
('45','23','email_subject_new_comment','New ticket comment'),
('46','24','menu_title','Discussions'),
('47','24','listing_heading','Discussions'),
('48','24','window_heading','Discussion Info'),
('49','24','insert_button','Add Discussion'),
('50','24','email_subject_new_item','New Discussion:'),
('51','24','use_comments','1'),
('52','24','email_subject_new_comment','New discussion comment:'),
('53','21','use_editor_in_comments','0'),
('54','22','use_editor_in_comments','0'),
('55','23','use_editor_in_comments','0'),
('56','24','use_editor_in_comments','0');

CREATE TABLE IF NOT EXISTS `app_entities_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `icon` varchar(64) NOT NULL,
  `entities_list` text NOT NULL,
  `reports_list` text NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_entity_1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `parent_item_id` int(11) NOT NULL DEFAULT '0',
  `linked_id` int(11) NOT NULL DEFAULT '0',
  `date_added` int(11) NOT NULL,
  `date_updated` int(11) NOT NULL DEFAULT '0',
  `created_by` int(11) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `password` varchar(255) NOT NULL,
  `field_5` text,
  `field_6` text,
  `field_7` text,
  `field_8` text,
  `field_9` text,
  `field_10` text,
  `field_12` text,
  `field_13` text,
  `field_14` text NOT NULL,
  `field_201` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_parent_item_id` (`parent_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_entity_1_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `items_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_fields_id` (`fields_id`),
  KEY `idx_items_fields_id` (`items_id`,`fields_id`),
  KEY `idx_value_id` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_entity_21` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT '0',
  `parent_item_id` int(11) DEFAULT '0',
  `linked_id` int(11) DEFAULT '0',
  `date_added` int(11) NOT NULL,
  `date_updated` int(11) NOT NULL DEFAULT '0',
  `created_by` int(11) DEFAULT NULL,
  `sort_order` int(11) DEFAULT '0',
  `field_156` text NOT NULL,
  `field_157` text NOT NULL,
  `field_158` text NOT NULL,
  `field_159` int(11) NOT NULL,
  `field_160` text NOT NULL,
  `field_161` text NOT NULL,
  `field_162` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_parent_item_id` (`parent_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_entity_21_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `items_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_fields_id` (`fields_id`),
  KEY `idx_items_fields_id` (`items_id`,`fields_id`),
  KEY `idx_value_id` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_entity_22` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT '0',
  `parent_item_id` int(11) DEFAULT '0',
  `linked_id` int(11) DEFAULT '0',
  `date_added` int(11) NOT NULL,
  `date_updated` int(11) NOT NULL DEFAULT '0',
  `created_by` int(11) DEFAULT NULL,
  `sort_order` int(11) DEFAULT '0',
  `field_167` text NOT NULL,
  `field_168` text NOT NULL,
  `field_169` text NOT NULL,
  `field_170` text NOT NULL,
  `field_171` text NOT NULL,
  `field_172` text NOT NULL,
  `field_173` varchar(64) NOT NULL,
  `field_174` varchar(64) NOT NULL,
  `field_175` int(11) NOT NULL,
  `field_176` int(11) NOT NULL,
  `field_177` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_parent_item_id` (`parent_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_entity_22_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `items_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_fields_id` (`fields_id`),
  KEY `idx_items_fields_id` (`items_id`,`fields_id`),
  KEY `idx_value_id` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_entity_23` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT '0',
  `parent_item_id` int(11) DEFAULT '0',
  `linked_id` int(11) DEFAULT '0',
  `date_added` int(11) NOT NULL,
  `date_updated` int(11) NOT NULL DEFAULT '0',
  `created_by` int(11) DEFAULT NULL,
  `sort_order` int(11) DEFAULT '0',
  `field_182` text NOT NULL,
  `field_183` text NOT NULL,
  `field_184` text NOT NULL,
  `field_185` text NOT NULL,
  `field_186` text NOT NULL,
  `field_194` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_parent_item_id` (`parent_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_entity_23_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `items_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_fields_id` (`fields_id`),
  KEY `idx_items_fields_id` (`items_id`,`fields_id`),
  KEY `idx_value_id` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_entity_24` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT '0',
  `parent_item_id` int(11) DEFAULT '0',
  `linked_id` int(11) DEFAULT '0',
  `date_added` int(11) NOT NULL,
  `date_updated` int(11) NOT NULL DEFAULT '0',
  `created_by` int(11) DEFAULT NULL,
  `sort_order` int(11) DEFAULT '0',
  `field_191` text NOT NULL,
  `field_192` text NOT NULL,
  `field_193` text NOT NULL,
  `field_195` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_parent_item_id` (`parent_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_entity_24_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `items_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_fields_id` (`fields_id`),
  KEY `idx_items_fields_id` (`items_id`,`fields_id`),
  KEY `idx_value_id` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `forms_tabs_id` int(11) NOT NULL,
  `comments_forms_tabs_id` int(11) NOT NULL DEFAULT '0',
  `type` varchar(64) NOT NULL,
  `name` varchar(255) NOT NULL,
  `short_name` varchar(64) DEFAULT NULL,
  `is_heading` tinyint(1) DEFAULT '0',
  `tooltip` text,
  `tooltip_display_as` varchar(16) NOT NULL DEFAULT '',
  `tooltip_in_item_page` tinyint(1) NOT NULL DEFAULT '0',
  `tooltip_item_page` text NOT NULL,
  `notes` text NOT NULL,
  `is_required` tinyint(1) DEFAULT '0',
  `required_message` text,
  `configuration` text,
  `sort_order` int(11) DEFAULT '0',
  `listing_status` tinyint(4) NOT NULL DEFAULT '0',
  `listing_sort_order` int(11) NOT NULL DEFAULT '0',
  `comments_status` tinyint(1) NOT NULL DEFAULT '0',
  `comments_sort_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_form_tabs_id` (`forms_tabs_id`),
  KEY `idx_comments_forms_tabs_id` (`comments_forms_tabs_id`)
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8;

INSERT INTO app_fields VALUES
('1','1','1','0','fieldtype_action','',NULL,NULL,NULL,'','0','','',NULL,NULL,NULL,NULL,'1','0','0','0'),
('2','1','1','0','fieldtype_id','',NULL,NULL,NULL,'','0','','',NULL,NULL,NULL,NULL,'1','1','0','0'),
('3','1','1','0','fieldtype_date_added','',NULL,NULL,NULL,'','0','','',NULL,NULL,NULL,NULL,'0','0','0','0'),
('4','1','1','0','fieldtype_created_by','',NULL,NULL,NULL,'','0','','',NULL,NULL,NULL,NULL,'0','0','0','0'),
('5','1','1','0','fieldtype_user_status','',NULL,NULL,NULL,'','0','','',NULL,NULL,NULL,'0','1','7','0','0'),
('6','1','1','0','fieldtype_user_accessgroups','',NULL,NULL,NULL,'','0','','',NULL,NULL,NULL,'1','1','2','0','0'),
('7','1','1','0','fieldtype_user_firstname','',NULL,NULL,NULL,'','0','','',NULL,NULL,'{\"allow_search\":\"1\"}','3','1','4','0','0'),
('8','1','1','0','fieldtype_user_lastname','',NULL,NULL,NULL,'','0','','',NULL,NULL,'{\"allow_search\":\"1\"}','4','1','5','0','0'),
('9','1','1','0','fieldtype_user_email','',NULL,NULL,NULL,'','0','','',NULL,NULL,'{\"allow_search\":\"1\"}','6','1','6','0','0'),
('10','1','1','0','fieldtype_user_photo','',NULL,NULL,NULL,'','0','','',NULL,NULL,NULL,'5','0','0','0','0'),
('12','1','1','0','fieldtype_user_username','',NULL,'1',NULL,'','0','','',NULL,NULL,'{\"allow_search\":\"1\"}','2','1','3','0','0'),
('13','1','1','0','fieldtype_user_language','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'7','0','0','0','0'),
('14','1','1','0','fieldtype_user_skin','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','0','0','0','0'),
('152','21','24','0','fieldtype_action','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','0','0','0'),
('153','21','24','0','fieldtype_id','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','1','0','0'),
('154','21','24','0','fieldtype_date_added','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','6','0','0'),
('155','21','24','0','fieldtype_created_by','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','7','0','0'),
('156','21','24','0','fieldtype_dropdown','Priority',NULL,'0',NULL,'','0','','','1',NULL,'{\"width\":\"input-medium\"}','0','1','2','1','0'),
('157','21','24','0','fieldtype_dropdown','Status',NULL,'0',NULL,'','0','','','1',NULL,'{\"width\":\"input-medium\"}','1','1','4','1','1'),
('158','21','24','0','fieldtype_input','Name',NULL,'1',NULL,'','0','','','1',NULL,'{\"allow_search\":\"1\",\"width\":\"input-xlarge\"}','2','1','3','0','0'),
('159','21','24','0','fieldtype_input_date','Start Date',NULL,'0',NULL,'','0','','','0',NULL,NULL,'3','1','5','0','0'),
('160','21','24','0','fieldtype_textarea_wysiwyg','Description',NULL,'0',NULL,'','0','','','0',NULL,'{\"allow_search\":\"1\"}','4','0','0','0','0'),
('161','21','25','0','fieldtype_users','Team',NULL,'0',NULL,'','0','','','0',NULL,'{\"display_as\":\"checkboxes\"}','0','0','0','0','0'),
('162','21','24','0','fieldtype_attachments','Attachments',NULL,'0',NULL,'','0','','','0',NULL,NULL,'5','0','0','0','0'),
('163','22','26','0','fieldtype_action','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','0','0','0'),
('164','22','26','0','fieldtype_id','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','1','0','0'),
('165','22','26','0','fieldtype_date_added','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','10','0','0'),
('166','22','26','0','fieldtype_created_by','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','11','0','0'),
('167','22','26','0','fieldtype_dropdown','Type',NULL,'0',NULL,'','0','','','1',NULL,'{\"width\":\"input-medium\"}','1','1','3','0','0'),
('168','22','26','0','fieldtype_input','Name',NULL,'1',NULL,'','0','','','1',NULL,'{\"allow_search\":\"1\",\"width\":\"input-xlarge\"}','2','1','4','0','0'),
('169','22','26','0','fieldtype_dropdown','Status',NULL,'0',NULL,'','0','','','1',NULL,'{\"width\":\"input-large\"}','3','1','5','1','0'),
('170','22','26','0','fieldtype_dropdown','Priority',NULL,'0',NULL,'','0','','','1',NULL,'{\"width\":\"input-medium\"}','4','1','2','1','1'),
('171','22','26','0','fieldtype_users','Assigned To',NULL,'0',NULL,'','0','','','0',NULL,'{\"display_as\":\"checkboxes\"}','5','1','6','0','0'),
('172','22','26','0','fieldtype_textarea_wysiwyg','Description',NULL,'0',NULL,'','0','','','0',NULL,'{\"allow_search\":\"1\"}','6','0','0','0','0'),
('173','22','27','0','fieldtype_input_numeric','Est. Time',NULL,'0',NULL,'','0','','','0',NULL,'{\"width\":\"input-small\",\"number_format\":\"2/./*\"}','1','1','7','0','0'),
('174','22','27','0','fieldtype_input_numeric_comments','Work Hours',NULL,'0',NULL,'','0','','','0',NULL,NULL,'2','1','8','1','2'),
('175','22','27','0','fieldtype_input_date','Start Date',NULL,'0',NULL,'','0','','','0',NULL,NULL,'3','0','0','0','0'),
('176','22','27','0','fieldtype_input_date','End Date',NULL,'0',NULL,'','0','','','0',NULL,NULL,'4','1','9','0','0'),
('177','22','26','0','fieldtype_attachments','Attachments',NULL,'0',NULL,'','0','','','0',NULL,NULL,'7','0','0','0','0'),
('178','23','28','0','fieldtype_action','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','0','0','0'),
('179','23','28','0','fieldtype_id','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','1','0','0'),
('180','23','28','0','fieldtype_date_added','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','6','0','0'),
('181','23','28','0','fieldtype_created_by','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','7','0','0'),
('182','23','28','0','fieldtype_grouped_users','Department',NULL,'0',NULL,'','0','','','1',NULL,NULL,'0','1','4','1','0'),
('183','23','28','0','fieldtype_dropdown','Type',NULL,'0',NULL,'','0','','','1',NULL,'{\"width\":\"input-large\"}','2','1','2','1','1'),
('184','23','28','0','fieldtype_input','Subject',NULL,'1',NULL,'','0','','','1',NULL,'{\"allow_search\":\"1\",\"width\":\"input-xlarge\"}','3','1','3','0','0'),
('185','23','28','0','fieldtype_textarea_wysiwyg','Description',NULL,'0',NULL,'','0','','','0',NULL,'{\"allow_search\":\"1\"}','4','0','0','0','0'),
('186','23','28','0','fieldtype_dropdown','Status',NULL,'0',NULL,'','0','','','1',NULL,'{\"width\":\"input-large\"}','1','1','5','1','2'),
('187','24','29','0','fieldtype_action','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','0','0','0'),
('188','24','29','0','fieldtype_id','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','1','0','0'),
('189','24','29','0','fieldtype_date_added','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','4','0','0'),
('190','24','29','0','fieldtype_created_by','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','1','5','0','0'),
('191','24','29','0','fieldtype_input','Name',NULL,'1',NULL,'','0','','','1',NULL,'{\"allow_search\":\"1\",\"width\":\"input-xlarge\"}','1','1','3','0','0'),
('192','24','29','0','fieldtype_textarea_wysiwyg','Description',NULL,'0',NULL,'','0','','','0',NULL,'{\"allow_search\":\"1\"}','2','0','0','0','0'),
('193','24','29','0','fieldtype_dropdown','Status',NULL,'0',NULL,'','0','','','0',NULL,'{\"width\":\"input-medium\"}','0','1','2','1','0'),
('194','23','28','0','fieldtype_attachments','Attachments',NULL,'0',NULL,'','0','','','0',NULL,NULL,'5','0','0','0','0'),
('195','24','29','0','fieldtype_attachments','Attachments',NULL,'0',NULL,'','0','','','0',NULL,NULL,'3','0','0','0','0'),
('196','1','1','0','fieldtype_parent_item_id','',NULL,NULL,NULL,'','0','','',NULL,NULL,NULL,NULL,'1','100','0','0'),
('197','21','24','0','fieldtype_parent_item_id','',NULL,NULL,NULL,'','0','','',NULL,NULL,NULL,NULL,'1','100','0','0'),
('198','22','26','0','fieldtype_parent_item_id','',NULL,NULL,NULL,'','0','','',NULL,NULL,NULL,NULL,'1','100','0','0'),
('199','23','28','0','fieldtype_parent_item_id','',NULL,NULL,NULL,'','0','','',NULL,NULL,NULL,NULL,'1','100','0','0'),
('200','24','29','0','fieldtype_parent_item_id','',NULL,NULL,NULL,'','0','','',NULL,NULL,NULL,NULL,'1','100','0','0'),
('201','1','1','0','fieldtype_user_last_login_date','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'0','0','0','0','0'),
('202','1','1','0','fieldtype_date_updated','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'3','0','0','0','0'),
('203','21','24','0','fieldtype_date_updated','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'3','0','0','0','0'),
('204','22','26','0','fieldtype_date_updated','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'3','0','0','0','0'),
('205','23','28','0','fieldtype_date_updated','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'3','0','0','0','0'),
('206','24','29','0','fieldtype_date_updated','',NULL,'0',NULL,'','0','','','0',NULL,NULL,'3','0','0','0','0');

CREATE TABLE IF NOT EXISTS `app_fields_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `access_groups_id` int(11) NOT NULL,
  `entities_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `access_schema` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_fields_id` (`fields_id`),
  KEY `idx_access_groups_id` (`access_groups_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_fields_choices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `fields_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `is_default` tinyint(1) DEFAULT NULL,
  `bg_color` varchar(16) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `users` text,
  `value` varchar(64) NOT NULL,
  `filename` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_fields_id` (`fields_id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8;

INSERT INTO app_fields_choices VALUES
('34','0','156','Urgent','0',NULL,'1',NULL,'',''),
('35','0','156','High','0',NULL,'2',NULL,'',''),
('37','0','157','New','0',NULL,'1',NULL,'',''),
('38','0','157','Open','0',NULL,'2',NULL,'',''),
('39','0','157','Waiting','0',NULL,'3',NULL,'',''),
('40','0','157','Closed','0',NULL,'4',NULL,'',''),
('41','0','157','Canceled','0',NULL,'5',NULL,'',''),
('42','0','167','Task','1',NULL,'1',NULL,'',''),
('43','0','167','Change','0',NULL,'2',NULL,'',''),
('44','0','167','Bug','0','#ff7a00','3',NULL,'',''),
('45','0','167','Idea','0',NULL,'0',NULL,'',''),
('46','0','169','New','1',NULL,'0',NULL,'',''),
('47','0','169','Open','0',NULL,'2',NULL,'',''),
('48','0','169','Waiting','0',NULL,'3',NULL,'',''),
('49','0','169','Done','0',NULL,'4',NULL,'',''),
('50','0','169','Closed','0',NULL,'5',NULL,'',''),
('51','0','169','Paid','0',NULL,'6',NULL,'',''),
('52','0','169','Canceled','0',NULL,'7',NULL,'',''),
('53','0','170','Urgent','0','#ff0000','1',NULL,'',''),
('54','0','170','High','0',NULL,'2',NULL,'',''),
('55','0','170','Medium','1',NULL,'3',NULL,'',''),
('56','0','182','Support','0',NULL,'0',NULL,'',''),
('57','0','183','Request a Change','0',NULL,'1',NULL,'',''),
('58','0','183','Report a Bug','0',NULL,'2',NULL,'',''),
('59','0','183','Ask a Question','0',NULL,'3',NULL,'',''),
('60','0','186','New','1',NULL,'0',NULL,'',''),
('61','0','186','Open','0',NULL,'2',NULL,'',''),
('62','0','186','Waiting On Client','0',NULL,'3',NULL,'',''),
('63','0','186','Closed','0',NULL,'4',NULL,'',''),
('64','0','186','Canceled','0',NULL,'5',NULL,'',''),
('65','0','193','Open','0',NULL,'1',NULL,'',''),
('66','0','193','Closed','0',NULL,'2',NULL,'',''),
('67','0','193','New','1',NULL,'0',NULL,'','');

CREATE TABLE IF NOT EXISTS `app_forms_fields_rules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entities_id` int(10) unsigned NOT NULL,
  `fields_id` int(10) unsigned NOT NULL,
  `choices` text NOT NULL,
  `visible_fields` text NOT NULL,
  `hidden_fields` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_fields_id` (`fields_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_forms_tabs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `description` text NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

INSERT INTO app_forms_tabs VALUES
('1','1','Info','','0'),
('24','21','Info','','0'),
('25','21','Team','','1'),
('26','22','Info','','0'),
('27','22','Time','','1'),
('28','23','Info','','0'),
('29','24','Info','','0');

CREATE TABLE IF NOT EXISTS `app_global_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_global_lists_choices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `lists_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `is_default` tinyint(1) DEFAULT NULL,
  `bg_color` varchar(16) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `users` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_lists_id` (`lists_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_help_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `type` varchar(16) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `icon` varchar(64) NOT NULL,
  `start_date` int(11) NOT NULL,
  `end_date` int(11) NOT NULL,
  `description` text NOT NULL,
  `color` varchar(16) NOT NULL,
  `position` varchar(16) NOT NULL,
  `users_groups` text NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_entities_id` (`entities_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_holidays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_image_map_labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `map_id` int(11) NOT NULL,
  `choices_id` int(11) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_map_id` (`map_id`),
  KEY `idx_choices_id` (`choices_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_image_map_markers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `items_id` int(11) NOT NULL,
  `map_id` int(11) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_map_id` (`map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_items_export_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `templates_fields` text NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cidx` (`entities_id`,`users_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_listing_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `listing_types_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `fields` text NOT NULL,
  `display_as` varchar(16) NOT NULL,
  `display_field_names` tinyint(1) NOT NULL,
  `text_align` varchar(16) NOT NULL,
  `width` varchar(16) NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_listing_types_id` (`listing_types_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_listing_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `type` varchar(16) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_default` tinyint(4) NOT NULL,
  `width` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_mind_map` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `items_id` int(11) DEFAULT NULL,
  `fields_id` int(11) DEFAULT NULL,
  `reports_id` int(11) DEFAULT NULL,
  `mm_id` varchar(64) NOT NULL,
  `mm_parent_id` varchar(64) NOT NULL,
  `mm_text` varchar(255) NOT NULL,
  `mm_layout` varchar(16) NOT NULL,
  `mm_shape` varchar(16) NOT NULL,
  `mm_side` varchar(16) NOT NULL,
  `mm_color` varchar(16) NOT NULL,
  `mm_icon` varchar(32) NOT NULL,
  `mm_collapsed` varchar(1) NOT NULL,
  `mm_value` varchar(64) NOT NULL,
  `mm_items_id` int(11) DEFAULT '0',
  `parent_entity_item_id` int(11) NOT NULL DEFAULT '0',
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_fields_id` (`fields_id`),
  KEY `idx_reports_id` (`reports_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_related_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `items_id` int(11) NOT NULL,
  `related_entities_id` int(11) NOT NULL,
  `related_items_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_related_entities_id` (`related_entities_id`),
  KEY `idx_related_items_id` (`related_items_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `entities_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `reports_type` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `menu_icon` varchar(64) NOT NULL DEFAULT '',
  `in_menu` tinyint(1) NOT NULL DEFAULT '0',
  `in_dashboard` tinyint(4) NOT NULL DEFAULT '0',
  `in_dashboard_counter` tinyint(1) NOT NULL DEFAULT '0',
  `in_dashboard_icon` tinyint(1) NOT NULL,
  `in_dashboard_counter_color` varchar(16) NOT NULL,
  `in_dashboard_counter_fields` varchar(255) NOT NULL,
  `dashboard_counter_hide_count` tinyint(1) NOT NULL DEFAULT '0',
  `dashboard_counter_sum_by_field` int(11) NOT NULL,
  `in_header` tinyint(1) NOT NULL DEFAULT '0',
  `in_header_autoupdate` tinyint(1) NOT NULL,
  `dashboard_sort_order` int(11) DEFAULT NULL,
  `header_sort_order` int(11) NOT NULL DEFAULT '0',
  `dashboard_counter_sort_order` int(11) NOT NULL DEFAULT '0',
  `listing_order_fields` text NOT NULL,
  `users_groups` text,
  `displays_assigned_only` tinyint(1) NOT NULL DEFAULT '0',
  `parent_entity_id` int(11) NOT NULL DEFAULT '0',
  `parent_item_id` int(11) NOT NULL DEFAULT '0',
  `fields_in_listing` text,
  `rows_per_page` int(11) NOT NULL DEFAULT '0',
  `notification_days` varchar(32) NOT NULL,
  `notification_time` varchar(255) NOT NULL,
  `listing_type` varchar(16) NOT NULL,
  `listing_col_width` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_parent_entity_id` (`parent_entity_id`),
  KEY `idx_parent_item_id` (`parent_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;

INSERT INTO app_reports VALUES
('59','0','21','0','default','','','0','0','0','0','','','0','0','0','0',NULL,'0','0','',NULL,'0','0','0',NULL,'0','','','',''),
('61','0','22','0','default','','','0','0','0','0','','','0','0','0','0',NULL,'0','0','',NULL,'0','0','0',NULL,'0','','','',''),
('63','0','23','0','default','','','0','0','0','0','','','0','0','0','0',NULL,'0','0','',NULL,'0','0','0',NULL,'0','','','','');

CREATE TABLE IF NOT EXISTS `app_reports_filters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reports_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `filters_values` text NOT NULL,
  `filters_condition` varchar(64) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_reports_id` (`reports_id`),
  KEY `idx_fields_id` (`fields_id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8;

INSERT INTO app_reports_filters VALUES
('68','59','157','37,38,39','include','1'),
('70','61','169','46,47,48','include','1'),
('72','63','186','60,61,62','include','1');

CREATE TABLE IF NOT EXISTS `app_reports_filters_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fields_id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL,
  `filters_values` text NOT NULL,
  `filters_condition` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cidx` (`fields_id`,`users_id`),
  KEY `idx_fields_id` (`fields_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_reports_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `menu_icon` varchar(64) NOT NULL,
  `in_menu` tinyint(1) NOT NULL,
  `sort_order` smallint(6) NOT NULL,
  `counters_list` text NOT NULL,
  `reports_list` text NOT NULL,
  `created_by` int(11) NOT NULL,
  `is_common` tinyint(1) NOT NULL DEFAULT '0',
  `users_groups` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_reports_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_by` int(11) NOT NULL,
  `reports_groups_id` int(11) NOT NULL,
  `report_left` varchar(64) NOT NULL,
  `report_right` varchar(64) NOT NULL,
  `sort_order` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_reports_groups_id` (`reports_groups_id`),
  KEY `idx_created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_sessions` (
  `sesskey` varchar(32) NOT NULL,
  `expiry` int(11) unsigned NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`sesskey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_user_filters_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filters_id` int(11) NOT NULL,
  `reports_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `filters_values` text,
  `filters_condition` varchar(64) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_filters_id` (`filters_id`),
  KEY `idx_reports_id` (`reports_id`),
  KEY `idx_fields_id` (`fields_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_users_alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `is_active` tinyint(1) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `type` varchar(16) NOT NULL,
  `location` varchar(16) NOT NULL,
  `start_date` int(11) NOT NULL,
  `end_date` int(11) NOT NULL,
  `assigned_to` text NOT NULL,
  `users_groups` text NOT NULL,
  `created_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_users_alerts_viewed` (
  `users_id` int(11) NOT NULL,
  `alerts_id` int(11) NOT NULL,
  KEY `idx_ueser_alerts` (`users_id`,`alerts_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_users_configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(11) NOT NULL,
  `configuration_name` varchar(255) NOT NULL DEFAULT '',
  `configuration_value` text,
  PRIMARY KEY (`id`),
  KEY `idx_users_id` (`users_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_users_filters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reports_id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `fields_in_listing` text NOT NULL,
  `listing_order_fields` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_reports_id` (`reports_id`),
  KEY `idx_users_id` (`users_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_users_login_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(11) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `is_success` tinyint(1) NOT NULL,
  `date_added` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_users_id` (`users_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_users_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(11) NOT NULL,
  `entities_id` int(11) NOT NULL,
  `items_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `type` varchar(16) NOT NULL,
  `date_added` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_users_id` (`users_id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_uei` (`users_id`,`entities_id`) USING BTREE,
  KEY `idx_created_by` (`created_by`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_users_search_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(11) NOT NULL,
  `reports_id` int(11) NOT NULL,
  `configuration_name` varchar(255) NOT NULL,
  `configuration_value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_users_id` (`users_id`),
  KEY `idx_users_reports_id` (`users_id`,`reports_id`),
  KEY `idx_reports_id` (`reports_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_filters_panels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_active_filters` tinyint(1) NOT NULL,
  `position` varchar(16) NOT NULL,
  `users_groups` text NOT NULL,
  `width` tinyint(1) NOT NULL,
  `sort_order` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_filters_panels_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `panels_id` int(11) NOT NULL,
  `entities_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `width` varchar(16) NOT NULL,
  `height` varchar(16) NOT NULL,
  `display_type` varchar(32) NOT NULL,
  `exclude_values` text NOT NULL,
  `sort_order` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_panels_id` (`panels_id`),
  KEY `idx_fields_id` (`fields_id`),
  KEY `idx_entities_id` (`entities_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_fields_id` (`fields_id`),
  KEY `idx_entities_id` (`entities_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_user_roles_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_roles_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `entities_id` int(11) NOT NULL,
  `access_schema` varchar(255) NOT NULL,
  `comments_access` varchar(64) NOT NULL,
  `fields_access` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_fields_id` (`fields_id`),
  KEY `idx_user_roles_id` (`user_roles_id`),
  KEY `entities_id` (`entities_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_user_roles_to_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fields_id` int(11) NOT NULL,
  `entities_id` int(11) NOT NULL,
  `items_id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL,
  `roles_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_roles_id` (`roles_id`),
  KEY `idx_users_id` (`users_id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_fields_id` (`fields_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `app_approved_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL,
  `items_id` int(11) NOT NULL,
  `fields_id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL,
  `signature` text NOT NULL,
  `date_added` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entities_id` (`entities_id`),
  KEY `idx_items_id` (`items_id`),
  KEY `idx_fields_id` (`fields_id`),
  KEY `idx_users_id` (`users_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

