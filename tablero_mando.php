<?php include('header.php'); ?>
<?php include('session.php'); ?>
<head>
<title>Tablero de mando</title>
<!--
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
-->
<!--
<link rel="shortcut icon" href="#" />
-->
<!-- Bootstrap CSS 
<link rel="stylesheet" href="bootstrap\css\bootstrap.min.css">
-->
<!-- CSS personalizado -->
<link rel="stylesheet" href="datatable\main.css">
 
<!--datables CSS básico
<link rel="stylesheet" type="text/css" href="admin\datatable\datatables.css"/>
-->
<!--datables estilo bootstrap 4 CSS  -->
<link rel="stylesheet"  type="text/css" href="datatable\DataTables-1.10.24\css\dataTables.bootstrap4.min.css">

<!--Para botones-->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">     
</head>

<body>
	<?php include('navbar.php'); ?>
        <div class="container-fluid">
            <div class="row-fluid">
                <!-- Menu lateral -->  
				
                <div style=" margin: 0 auto;" id="content">
                     <div >
                        <h3 style="text-align: center;">TABLERO DE MANDO</h3>
                        <!-- interfaz para administrar regiones -->		
	
                        <!-- Consulta y ciclo para hacer el conteo de las compras agregadas y los totales y promedio -->	
                        <?php	
                            $count_user=mysql_query("select * from tablero");
                            $count = mysql_num_rows($count_user);    	
                        ?>	
                     
                         <!-- BOTON AGREGAR Y EXPORTAR A EXCEL-->
                         <!-- Y codigo php para dar permiso de agregar al usuario administrador -->
                        <?php
                        $user_query = mysql_query("select * from admin where id_cargo = '1'") or die(mysql_error());
                        $user_row = mysql_fetch_array($user_query);
                        $id = $row['id_cargo'];
                        ?>
                        <?php if ($row['id_cargo'] == 1) { ?>
                        <div class="row-fluid"> 
                            <a  href="add_tablero.php" class="btn btn-primary"  id="add" data-placement="right" title="" >
                            <i class="icon-plus-sign icon-large"></i> Agregar medicamento</a>
                            <?php } ?>
                            <br>
                            <div id="block_bg" class="block">
                                <div class="navbar navbar-inner block-header">
                                    <div class="muted pull-left"></i><i class="fa fa-medkit"></i> Tablero de mando  </div>
                                    <div class="muted pull-right">
                                    Numero de Medicamentos : <span class="badge badge-info"><?php  echo $count; ?></span>
                                    </div>
                                    <br><br>
                                </div>
                                <div class="block-content collapse in">
                                    <div class="span12">
								        <form action="delete_tablero.php" method="post">
                                            <div class="table-responsive" >
  									        <table  id="tabla" class="table table-striped table-bordered" cellspacing="0" width="100%">
                                                <?php if ($row['id_cargo'] == 1) { ?>
                                                <a data-placement="right"   data-toggle="modal" href="#tablero_delete" id="delete"  class="btn btn-danger" name=""><i class="icon-trash icon-large"> Borrar</i></a>
									            <?php include('modal_delete.php'); ?>
                                                <?php } ?>
										        <thead>
										        <tr style="font-size: 14px;">
												<th></th>
                                                <th style="text-align: center;" >Codigo</th>
                                                <th style="text-align: center;" >Medicamento</th>
                                                <th style="text-align: center;" >U/P</th>
                                                <th style="text-align: center;" >Programacion 2021</th>
                                                <th style="text-align: center;" >CPM</th>
                                                <th style="text-align: center;" >Existencias</th>
                                                <th style="text-align: center;" >Transito</th>
                                                <th style="text-align: center;" >Meses de cobertura</t>
                                                <th style="text-align: center;">Acciones</th>
										        </tr>
										        </thead>
										        <tbody>
													<?php
													$user_query = mysql_query("select * from tablero ")or die(mysql_error());
													while($row = mysql_fetch_array($user_query)){
													$id = $row['id_tablero'];
													?>
									
                                                    <tr style="font-size: 13px;">
                                                    <td width="30" id="uniform-undefined" class="checker">
                                                    <input id="optionsCheckbox" class="checked" name="selector[]" type="checkbox" value="<?php echo $id; ?>">
                                                    </td>
                                                    <td ><?php echo $row['codigo']; ?></td>
                                                    <td style="text-align: center;"><?php echo $row['medicamento']; ?></td>
                                                    <td style="text-align: center;"><?php echo $row['up']; ?></td>
                                                    <td style="text-align: center"><?php echo $row['programado']; ?></td>
                                                    <td style="text-align: center"><?php echo round ($row['cpm'],1); ?></td>	
                                                    <td style="text-align: center"><?php echo $row['existencia']; ?></td>	 		
                                                    <td style="text-align: center"><?php echo $row['transito']; ?></td>
                                                    <td style="text-align: center"><?php echo round ($row['cobertura'],1); ?></td>	 		 									
                                                    <td width="100">
                                                    <a rel="tooltip"   id="e<?php echo $id; ?>" href="editar_tablero.php<?php echo '?id='.$id; ?>"  data-toggle="modal" class="btn btn-success"><i class="icon-pencil icon-large"> Editar </i></a>
                                                    </td>
                                                    </tr>
                                                    <?php } ?>
										        </tbody>
									        </table>
                                            </div>
                                        </form>
								    </div>
								</div>
							</div>
						</div>
                    </div>
                </div>
            </div>
        </div>
    <!-- datatables JS -->
    
    <script type="text/javascript" src="datatable\datatables.min.js"></script>
        
    <script src="librerias/datatables/js/jquery.dataTables.min.js"></script>
    <script src="estilos/DT_bootstrap.js"></script>
    <script src="estilos/scripts.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
     <!-- para usar botones en datatables JS -->  
     <script src="datatable\Buttons-1.7.0\js\dataTables.buttons.min.js"></script>  
     <script src="datatable\JSZip-2.5.0\jszip.min.js"></script>    
     <script src="datatable\pdfmake-0.1.36\pdfmake.min.js"></script>
         
     <script src="datatable\pdfmake-0.1.36\vfs_fonts.js"></script>
     
     <script src="datatable\Buttons-1.7.0\js\buttons.html5.min.js"></script>
      
     <!-- código JS propìo para la tabla y botones-->    
     <script type="text/javascript" src="datatable\main.js"></script>                                                                                                 
</body>

