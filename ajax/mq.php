<?php 
require_once "../modelos/medicamentos.php";

$cliente=new cliente();
;

switch ($_GET["op"]){
	
    case 'listarmq':

            $rspta=$cliente->listarmq();
             //Vamos a declarar un array
             
             $data= Array();
             
             while ($reg=$rspta->fetch_object()){
                 $data[]=array(
                     "0"=>'<button class="btn btn-warning" onclick="agregarclientescab('.$reg->id.',\''.$reg->nombre.'\',\''.$reg->codigo.'\')"><span class="fa fa-plus"></span></button>',
                     "1"=>$reg->id,
                      "2"=>$reg->nombre,
                      "3"=>$reg->codigo, 
                      "4"=>$reg->unidades
                    
                     );
             }
             $results = array(
                 "sEcho"=>1, //Información para el datatables
                 "iTotalRecords"=>count($data), //enviamos el total registros al datatable
                 "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
                 "aaData"=>$data);
             echo json_encode($results);
    
        break;
        case 'mostrar':
            $rspta=$cliente->mostrar($id);
             //Codificar el resultado utilizando json
             echo json_encode($rspta);
        break;

	
}
}
?>