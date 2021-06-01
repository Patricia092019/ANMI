<?php include_once "includes/header.php"; ?>
<head>
	<title> Citas de Proovedores </title>
	<!-- CSS personalizado -->
<link rel="stylesheet" href="datatable\main.css">

 <!--datables estilo bootstrap 4 CSS  -->
 <link rel="stylesheet"  type="text/css" href="datatable\DataTables-1.10.24\css\dataTables.bootstrap4.min.css">
 
 <!--Para botones-->
 <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
</head>

<body>
	
        <div class="container-fluid">
            <div class="row-fluid">
                <!-- Menu lateral -->  
				
                <div class="span12" id="content">
                     <div class="row-fluid ">
                        <h3 style="text-align: center;">CITAS A PROVEEDORES</h3>	
                         <!--BOTON AGREGAR -->
                        <div class="row-fluid"> 
                            <a  href="add_citas.php" class="btn btn-primary"  id="add" data-placement="right" title="" >
                            <i class="icon-plus-sign icon-large"></i> Agregar Cita </a>
                            <br>
                            <div id="block_bg" class="block">
                                <div class="navbar navbar-inner block-header">
                                    <div class="muted pull-left"></i><i class="fa fa-medkit"></i> Programacion de citas </div>
                                </div>
                                
                                   
								        <form action="delete_citas.php" method="post">
                                            <div class="table-responsive" >
                                            <table class="table table-hover" id="table">
					<thead  style="background-color:#0e4f91" class="table-dark">
                    <tr>
                        <th style="text-align: center;" >Codigo</th>
                        <th style="text-align: center;" >Medicamento</th>
                        <th style="text-align: center;" >U/P</th>
                        <th style="text-align: center;" >Programacion 2021</th>
                        <th style="text-align: center;" >CPM</th>
                        <th style="text-align: center;" >Existencias</th>
                        <th style="text-align: center;" >Transito</th>
                        <th style="text-align: center;" >Meses de cobertura</t>
						<?php if ($_SESSION['rol'] == 1) { ?>
                        <th style="text-align: center;">Acciones</th>
						<?php } ?>
						</tr>
					</thead>
					<tbody>
						<?php
						include "../conexion.php";

						$query = mysqli_query($conexion, "SELECT * FROM tablero");
						$result = mysqli_num_rows($query);
						if ($result > 0) {
							while ($data = mysqli_fetch_assoc($query)) { ?>
								<tr>
									<td ><?php echo $data['codigo']; ?></td>
									<td ><?php echo $data['medicamento']; ?></td>
									<td style="text-align: center"><?php echo $data['up']; ?></td>
									<td style="text-align: center"><?php echo number_format($data['programado'],0, '.',',') ; ?></td>
                                    <td style="text-align: center"><?php echo number_format($data['cpm'],0, '.',',') ; ?></td>
                                    <td style="text-align: center"><?php echo number_format($data['existencia'],0, '.',','); ?></td>
                                    <td style="text-align: center"><?php echo number_format($data['transito'],0, '.',','); ?></td>
                                    <td style="text-align: center"><?php echo $data['cobertura']; ?></td>
									
									<?php if ($_SESSION['rol'] == 1) { ?>
									<td>
										<a href="editar_hospitales.php?id=<?php echo $data['id_hospital']; ?>" class="btn btn-success"><i class='fas fa-edit'></i></a>
										<form action="eliminar_hospital.php?id=<?php echo $data['id_hospital']; ?>" method="post" class="confirmar d-inline">
											<button class="btn btn-danger" type="submit"><i class='fas fa-trash-alt'></i> </button>
										</form>
									</td>
									<?php } ?>
								</tr>
						<?php }
						} ?>
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
</body>
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
         <?php include_once "includes/footer.php"; ?>
