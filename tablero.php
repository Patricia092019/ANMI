<?php include_once "includes/header.php"; ?>

<link rel="stylesheet" href="datatable\main.css">
 <!--datables estilo bootstrap 4 CSS  -->
 <link rel="stylesheet"  type="text/css" href="datatable\DataTables-1.10.24\css\dataTables.bootstrap4.min.css">
 <!--Para botones-->
 <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">

<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<div class="d-sm-flex align-items-center justify-content-between mb-4">
		<h1 class="h3 mb-0 text-gray-800">Tablero de mando</h1>
		<a href="registro_hospital.php" class="btn btn-primary">Agregar</a>
	</div>

	<div class="row">
		<div class="col-lg-12">
			
			<div class="table-responsive">
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

		</div>
	</div>


</div>
<!-- datatables JS -->

<?php include_once "includes/footer.php"; ?>