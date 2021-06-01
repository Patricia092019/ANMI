<?php include_once "includes/header.php"; ?>

<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<div class="d-sm-flex align-items-center justify-content-between mb-4">
		<h1 class="h3 mb-0 text-gray-800">Productos</h1>
		<a href="registro_producto.php" class="btn btn-primary">Nuevo</a>
	</div>

	<div class="row">
		<div class="col-lg-12">
			<div class="table-responsive">
				<table class="table table-hover" id="table" >
					<thead class="thead-dark" style="background-color:#0e4f91">
						<tr>
							<th>Codigo</th>
							<th>Nombre</th>
							<th>Presentacion</th>
							<?php if ($_SESSION['rol'] == 1) { ?>
							<th>Acciones</th>
							<?php } ?>
						</tr>
					</thead>
					<tbody>
						<?php
						include "../conexion.php";

						$query = mysqli_query($conexion, "SELECT * FROM producto");
						$result = mysqli_num_rows($query);
						if ($result > 0) {
							while ($data = mysqli_fetch_assoc($query)) { ?>
								<tr>
									<td><?php echo $data['codigo']; ?></td>
									<td><?php echo $data['nombre']; ?></td>
									<td><?php echo $data['unidades']; ?></td>
										<?php if ($_SESSION['rol'] == 1) { ?>
									<td>
										<a href="editar_producto.php?id=<?php echo $data['codigo']; ?>" class="btn btn-success"><i class='fas fa-edit'></i></a>

										<form action="eliminar_producto.php?id=<?php echo $data['codigo']; ?>" method="post" class="confirmar d-inline">
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