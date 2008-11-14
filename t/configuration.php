<?php
/**
* @version		$Id: configuration.php-dist 9991 2008-02-05 22:13:22Z ircmaxell $
* @package		Joomla
* @copyright	Copyright (C) 2005 - 2008 Open Source Matters. All rights reserved.
* @license		GNU/GPL, see LICENSE.php
* Joomla! is free software and parts of it may contain or be derived from the
* GNU General Public License or other free or open source software licenses.
* See COPYRIGHT.php for copyright notices and details.
*
* -------------------------------------------------------------------------
* THIS SHOULD ONLY BE USED AS A LAST RESORT WHEN THE WEB INSTALLER FAILS
*
* If you are installing Joomla! manually i.e. not using the web browser installer
* then rename this file to configuration.php e.g.
*
* UNIX -> mv configuration.php-dist configuration.php
* Windows -> rename configuration.php-dist configuration.php
*
* Now edit this file and configure the parameters for your site and
* database.
*/
class JConfig {
	/**
	* -------------------------------------------------------------------------
	* Site configuration section
	* -------------------------------------------------------------------------
	*/
	/* Site Settings */
	var $offline = '0';
	var $offline_message = 'This site is down for maintenance.<br /> Please check back again soon.';
	var $sitename = 'Joomla!';			// Name of Joomla site
	var $editor = 'tinymce';
	var $list_limit = '20';
	var $legacy = '0';

	/**
	* -------------------------------------------------------------------------
	* Database configuration section
	* -------------------------------------------------------------------------
	*/
	/* Database Settings */
	var $dbtype = 'mysql';					// Normally mysql
	var $host = 'localhost';				// This is normally set to localhost
	var $user = '';							// MySQL username
	var $password = '';						// MySQL password
	var $db = '';							// MySQL database name
	var $dbprefix = 'jos_';					// Do not change unless you need to!

	/* Server Settings */
	var $secret = 'FBVtggIk5lAzEU9H'; 		//Change this to something more secure
	var $gzip = '0';
	var $error_reporting = '-1';
	var $helpurl = 'http://help.joomla.org';
	var $xmlrpc_server = '1';
	var $ftp_host = '';
	var $ftp_port = '';
	var $ftp_user = '';
	var $ftp_pass = '';
	var $ftp_root = '';
	var $ftp_enable = '';
	var $tmp_path	= '/tmp';
	var $log_path	= '/var/logs';
	var $offset = '0';
	var $live_site = ''; 					// Optional, Full url to Joomla install.

	/* Session settings */
	var $lifetime = '15';					// Session time
	var $session_handler = 'database';

	/* Mail Settings */
	var $mailer = 'mail';
	var $mailfrom = '';
	var $fromname = '';
	var $sendmail = '/usr/sbin/sendmail';
	var $smtpauth = '0';
	var $smtpuser = '';
	var $smtppass = '';
	var $smtphost = 'localhost';

	/* Cache Settings */
	var $caching = '0';
	var $cachetime = '15';
	var $cache_handler = 'file';

	/* Debug Settings */
	var $debug      = '0';
	var $debug_db 	= '0';
	var $debug_lang = '0';

	/* Meta Settings */
	var $MetaDesc = 'Joomla! - the dynamic portal engine and content management system';
	var $MetaKeys = 'joomla, Joomla';
	var $MetaTitle = '1';
	var $MetaAuthor = '1';

	/* SEO Settings */
	var $sef = '0';
	var $sef_rewrite = '0';
	var $sef_suffix = '';

	/* Feed Settings */
	var $feed_limit   = 10;
}
?>
