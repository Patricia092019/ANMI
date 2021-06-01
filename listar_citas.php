<?php include_once "includes/header.php"; ?>

<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<div class="d-sm-flex align-items-center justify-content-between mb-4">
		<h1 class="h3 mb-0 text-gray-800">Citas de Proveedores</h1>
		<a href="registro_ncita.php" class="btn btn-primary">Nuevo</a>
	</div>

<div class="row">
		<div class="col-lg-12">

			<div class="table-responsive">
				<table class="table table-hover" id="table">
					<thead  style="background-color:#0e4f91" class="table-dark">
						<tr>
                        <th style="text-align: center">Id</th>
                        <th style="text-align: center">Fecha</th>
                        <th style="text-align: center">Hora </th>
				    	<th style="text-align: center">Proveedor</th>
						<th style="text-align: center">Licitacion</th>
                        <th style="text-align: center">Mediacamento</th>
                        <th style="text-align: center">Cantidad a Recibir</th>
                        <th style="text-align: center">Bodega</th>
                        <th style="text-align: center">Observaciones</th>
                        <th style="text-align: center">ACCIONES</th>
							
						</tr>
					</thead>
					<tbody>
						<?php
						include "../conexion.php";

						$query = mysqli_query($conexion, "SELECT * FROM citas");
						$result = mysqli_num_rows($query);
						if ($result > 0) {
							while ($data = mysqli_fetch_assoc($query)) { ?>
								<tr>
									<td style="text-align: center"><?php echo $data['Id']; ?></td>
									<td style="text-align: center"><?php echo $data['fecha']; ?></td>
									<td style="text-align: center"><?php echo $data['hora']; ?></td>
									<td style="text-align: center"><?php echo $data['laboratorio']; ?></td>
									<td style="text-align: center"><?php echo $data['referencia']; ?></td>
                                    <td style="text-align: center"><?php echo $data['medicamento']; ?></td>
                                    <td style="text-align: center"><?php echo $data['cantidad']; ?></td>
                                    <td style="text-align: center"><?php echo $data['bodega']; ?></td>
                                    <td style="text-align: center"><?php echo $data['observaciones']; ?></td>
									
									<td>
										<a href="editar_hospitales.php?id=<?php echo $data['id_hospital']; ?>" class="btn btn-success"><i class='fas fa-edit'></i></a>
										<form action="eliminar_hospital.php?id=<?php echo $data['id_hospital']; ?>" method="post" class="confirmar d-inline">
											<button class="btn btn-danger" type="submit"><i class='fas fa-trash-alt'></i> </button>
										</form>
									</td>
									<?php } ?>
								</tr>
						<?php }
						 ?>
					</tbody>

				</table>
			</div>

		</div>
	</div>


</div>
<!-- /.container-fluid -->


<?php include_once "includes/footer.php"; ?>