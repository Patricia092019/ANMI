function mostrarform(flag)
{
	limpiar();
	if (flag)
	{
	
		$("#btnGuardar").prop("disabled",false);
		$("#btnagregar").hide();
		listarmq();
		$("#boton").hide();
		$("#btnGuardar").hide();
		$("#btnCancelar").show();
		$("#btnAgregarcli").show();

	}
	else
	{
		$("#btnagregar").show();
		$("#boton").show();
	}
}

function listarmq()
{
	tabla=$('#tblmq').dataTable(
	{
		"aProcessing": true,//Activamos el procesamiento del datatables
	    "aServerSide": true,//Paginación y filtrado realizados por el servidor
	    dom: 'Bfrtip',//Definimos los elementos del control de tabla
	    buttons: [		          
		            
		        ],
		"ajax":
				{
					url: '../ajax/mq.php?op=listarmq',
					type : "get",
					dataType : "json",						
					error: function(e){
						console.log(e.responseText);	
					}
				},
		"bDestroy": true,
		"iDisplayLength": 5,//Paginación
	    "order": [[ 0, "desc" ]]//Ordenar (columna,orden)
	}).DataTable();
}
function mostrar(id)
{
	$.post("../ajax/venta_1.php?op=mostrar",{id : id}, function(data, status)
	{
		data = JSON.parse(data);		
		mostrarform(true);

		$("#id").val(data.id);
		$("#nombre").val(data.nombre);
		$("#codigo").val(data.codigo);
		
		$("#btnAgregarcli").hide();
 	});

}
function agregarclientescab(id,nombre,codigo)
  {
	document.getElementById("id").innerHTML = nombre;
  	
    if (id!="")
    {
		document.formulario.id.value = id;
		document.formulario.cliente.value = nombre;
		document.formulario.codigo.value = codigo;
		
    }
    else
    {
    	alert("Error al ingresar el detalle, revisar los datos del Cita");
    }
  }
