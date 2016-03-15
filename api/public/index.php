<?php




/* Defines */

define('DS', DIRECTORY_SEPARATOR);
define('APP', dirname(dirname(__FILE__)).DS);




/* Uses */

use Phalcon\Loader;
use Phalcon\Mvc\Micro;
use Phalcon\Di\FactoryDefault;
use Phalcon\Session\Adapter\Files as Session;
use Phalcon\Config\Adapter\Ini as ConfigIni;
use Phalcon\Db\Adapter\Pdo\Mysql as PdoMysql;




function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}




/* Setting up Loader */

$loader		= new Loader();

$loader->registerDirs([
	APP.'controllers'.DS,
	APP.'models'.DS
])->register();



/* Setting DB & Configuration */

$di			= new FactoryDefault();
$config		= new ConfigIni(APP.'config.ini');

$di->set('db', function() use($config) {
	return new PdoMysql([
		'host'		=> $config->database->host,
		'username'	=> $config->database->username,
		'password'	=> $config->database->password,
		'dbname'	=> $config->database->dbname
	]);
});

$di->set('config', function() use ($config) {
	return $config;
}, true);

date_default_timezone_set($config->system->timezone);



/* Sessions */
ini_set('session.auto_start', false);
ini_set('session.use_trans_sid', true);
ini_set('session.use_cookies', true);
ini_set('session.use_only_cookies', false);
ini_set('session.name', $config->session->name);
ini_set('session.hash_function', 1);
ini_set('session.hash_bits_per_character', 6);

$di->set('session', function() {
	$session	= new Session();

	$session->start();

	return $session;
});



/* Routes */

$app		= new Micro($di);

$app->get('/api/auth',            [new AuthController(),    'infoAction']);
$app->post('/api/auth',           [new AuthController(),    'loginAction']);
$app->post('/api/auth/new',       [new AuthController(),    'registerAction']);
$app->delete('/api/auth',         [new AuthController(),    'logoutAction']);

$app->post('/api/users',          [new UsersController(),    'postAction']);
$app->put('/api/users/{id}',      [new UsersController(),    'putAction']);
$app->get('/api/users',           [new UsersController(),    'indexAction']);
$app->get('/api/users/{id}',      [new UsersController(),    'viewAction']);
$app->delete('/api/users/{id}',   [new UsersController(),    'deleteAction']);

$app->get('/api/groups',          [new GroupsController(),   'indexAction']);

$app->post('/api/records',        [new RecordsController(),  'postAction']);
$app->put('/api/records/{id}',    [new RecordsController(),  'putAction']);
$app->get('/api/records',         [new RecordsController(),  'indexAction']);
$app->get('/api/records/{id}',    [new RecordsController(),  'viewAction']);
$app->delete('/api/records/{id}', [new RecordsController(),  'deleteAction']);

$app->notFound(function() use ($app) {
	$app->response->setStatusCode(404, 'Not Found')->sendHeaders();
});

$app->error(function($exception) use ($app) {
	$app->response->setStatusCode(500, 'Internal Server Error')->sendHeaders();
	$app->response->setContentType('text/html')->sendHeaders();
});

$app->after(function() use ($app) {
	$app->response->setContentType('application/json')->sendHeaders();

	$result			= $app->getReturnedValue();

	if ($result) {
		//$result			= array_merge($result, [
		//	'server_time'	=> date('c', time())
		//]);

		echo json_encode($result);
	}
});

$app->handle();