<?php 
//Incluímos inicialmente la conexión a la base de datos
 include_once "includes/header.php"; 


Class producto
{
	//Implementamos nuestro constructor
	public function __construct()
	{

	}
	//Implementar un método para listar los registros
	public function listarmq()
	{
		$sql="SELECT id, nombre, codigo, unidades
		FROM producto where condicion=1";
		return ejecutarConsultaSimpleFila($sql);
	}
	public function mostrar()
	{
		$sql="SELECT id, nombre, codigo, unidades
		FROM producto ";
		return ejecutarConsultaSimpleFila($sql);
	}
}

?>