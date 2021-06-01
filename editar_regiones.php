<?php include_once "includes/header.php";
include "../conexion.php";
if (!empty($_POST)) {
  $alert = "";
  if (empty($_POST['Region']) || empty($_POST['mqprogramados']) || empty($_POST['Mqabastecido'])) {
    $alert = '<div class="alert alert-danger" role="alert">Todo los campos son requeridos</div>';
  } else {
    $idregion = $_GET['id'];
    $region = $_POST['Region'];
    $mqprogramados = $_POST['mqprogramados'];
    $Mqabastecido = $_POST['Mqabastecido'];
    $abastecimiento = $Mqabastecido/$mqprogramados*100;

    $sql_update = mysqli_query($conexion, "UPDATE regiones SET Region = '$region', mqprogramados = '$mqprogramados' , Mqabastecido = '$Mqabastecido',  abastecimiento = ' $abastecimiento' WHERE id_region = $idregion");

if ($sql_update) {
  $alert = '<div class="alert alert-success" role="alert">Region Actualizado correctamente</div>';
} else {
  $alert = '
  <div class="alert alert-danger" role="alert">
  Error al Actualizar el Region
  </div>';
}
}
}

// Mostrar Datos
if (empty($_REQUEST['id'])) {
  header("Location: listar_regiones.php");
  mysqli_close($conexion);
}
$idregion = $_REQUEST['id'];
$sql = mysqli_query($conexion, "SELECT * FROM regiones WHERE id_region = $idregion");
mysqli_close($conexion);
$result_sql = mysqli_num_rows($sql);
if ($result_sql == 0) {
  header("Location: listar_regiones.php");
} else {
  while ($data = mysqli_fetch_array($sql)) {
    $idregion = $data['id_region'];
    $region = $data['Region'];
    $mqprogramados = $data['mqprogramados'];
    $Mqabastecido = $data['Mqabastecido'];
  }
}
?>

<!-- Begin Page Content -->
<div class="container-fluid">
 <!-- Page Heading -->
 <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <a href="listar_regiones.php" class="btn btn-primary">Regresar</a>
    </div>
  <div class="row">
    <div class="col-lg-6 m-auto">
      <div class="card">
        <div class="card-header bg-primary">
          Modificar Region
        </div>
        <div class="card-body">
          <form class="" action="" method="post">
            <?php echo isset($alert) ? $alert : ''; ?>
            <input type="hidden" name="id" value="<?php echo $idregion; ?>">
            <div class="form-group">
              <label for="Region">Nombre de Region </label>
              <input type="text" placeholder="Ingrese " name="Region" id="Region" class="form-control" value="<?php echo $region; ?>">
            </div>
            <div class="form-group">
              <label  for="mqprogramados">Medicamentos Programados </label>
              <input type="text"placeholder="Ingrese # de Medicamentos " name="mqprogramados" id="mqprogramados" class="form-control" value="<?php echo $mqprogramados; ?>">
            </div>
            <div class="form-group">
            <label for="Mqabastecido">Medicamentos Abastecidos </label>
            <input type="text" placeholder="Ingrese # de Medicamentos"  name="Mqabastecido" id="Mqabastecido" class="form-control" value="<?php echo $Mqabastecido; ?>">
            </div>
            
            <button type="submit" class="btn btn-primary"><i class="fas fa-user-edit"></i> Guardar</button>
          </form>
        </div>
      </div>
    </div>
  </div>


</div>
<!-- /.container-fluid -->
<?php include_once "includes/footer.php"; ?>