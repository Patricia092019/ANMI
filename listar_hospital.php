<?php include_once "includes/header.php"; ?>

<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<div class="d-sm-flex align-items-center justify-content-between mb-4">
		<h1 class="h3 mb-0 text-gray-800">Hospitales</h1>
		<a href="registro_hospital.php" class="btn btn-primary">Nuevo</a>
	</div>

	<div class="row">
		<div class="col-lg-12">

			<div class="table-responsive">
				<table class="table table-hover" id="table">
					<thead  style="background-color:#0e4f91" class="table-dark">
						<tr>
                        <th style="text-align: center">Id</th>
                        <th style="text-align: center">Hospital</th>
                        <th style="text-align: center">Medicamentos Programados 2021</th>
				    	<th style="text-align: center">Medicamentos Abastecidos</th>
						<th style="text-align: center">% Abastecimiento</th>
							<?php if ($_SESSION['rol'] == 1) { ?>
							<th>ACCIONES</th>
							<?php } ?>
						</tr>
					</thead>
					<tbody>
						<?php
						include "../conexion.php";

						$query = mysqli_query($conexion, "SELECT * FROM hospitales");
						$result = mysqli_num_rows($query);
						if ($result > 0) {
							while ($data = mysqli_fetch_assoc($query)) { ?>
								<tr>
									<td style="text-align: center"><?php echo $data['id_hospital']; ?></td>
									<td style="text-align: center"><?php echo $data['Hospital']; ?></td>
									<td style="text-align: center"><?php echo $data['mqprogramados']; ?></td>
									<td style="text-align: center"><?php echo $data['Mqabastecido']; ?></td>
									<td style="text-align: center"><?php echo $data['abastecimiento']; ?><i> % </i></td>
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
<!-- /.container-fluid -->


<?php include_once "includes/footer.php"; ?>