<?php include_once "includes/header.php";
include "../conexion.php";
if (!empty($_POST)) {
  $alert = "";
  if (empty($_POST['Hospital']) || empty($_POST['mqprogramados']) || empty($_POST['Mqabastecido'])) {
    $alert = '<div class="alert alert-danger" role="alert">Todo los campos son requeridos</div>';
  } else {
    $idhospital = $_GET['id'];
    $hospital = $_POST['Hospital'];
    $mqprogramados = $_POST['mqprogramados'];
    $Mqabastecido = $_POST['Mqabastecido'];
    $abastecimiento = $Mqabastecido/$mqprogramados*100;
    
    $sql_update = mysqli_query($conexion, "UPDATE hospitales SET Hospital = '$hospital', mqprogramados = '$mqprogramados' , Mqabastecido = '$Mqabastecido',  abastecimiento = ' $abastecimiento' WHERE id_hospital = $idhospital");

    if ($sql_update) {
      $alert = '<div class="alert alert-success" role="alert">Hospital Actualizado correctamente</div>';
    } else {
      $alert = '
      <div class="alert alert-danger" role="alert">
 Error al Actualizar el Hospital
</div>';
    }
  }
}

// Mostrar Datos

if (empty($_REQUEST['id'])) {
  header("Location: listar_hospital.php");
  mysqli_close($conexion);
}
$idhospital = $_REQUEST['id'];
$sql = mysqli_query($conexion, "SELECT * FROM hospitales WHERE id_hospital = $idhospital");
mysqli_close($conexion);
$result_sql = mysqli_num_rows($sql);
if ($result_sql == 0) {
  header("Location: listar_hospital.php");
} else {
  while ($data = mysqli_fetch_array($sql)) {
    $idhospital = $data['id_hospital'];
    $hospital = $data['Hospital'];
    $mqprogramados = $data['mqprogramados'];
    $Mqabastecido = $data['Mqabastecido'];
  }
}
?>
<!-- Begin Page Content -->
<div class="container-fluid">
  <!-- Page Heading -->
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <a href="listar_hospital.php" class="btn btn-primary">Regresar</a>
    </div>
  <div class="row">
    <div class="col-lg-6 m-auto">
      <div class="card">
        <div class="card-header bg-primary">
          Modificar Hospital
        </div>
        <div class="card-body">
          <form class="" action="" method="post">
            <?php echo isset($alert) ? $alert : ''; ?>
            <input type="hidden" name="id" value="<?php echo $idhospital; ?>">
            <div class="form-group">
              <label for="Hospital">Nombre de Hospital </label>
              <input type="text" placeholder="Ingrese nombre "name="Hospital" id="Hospital" class="form-control" value="<?php echo $hospital; ?>">
            </div>
            <div class="form-group">
            <label for="mqprogramados">Medicamentos Programados </label>
           <input type="text" placeholder="Ingrese # de Medicamentos " name="mqprogramados" id="mqprogramados"class="form-control" value="<?php echo $mqprogramados; ?>">
            </div>
            <div class="form-group">
            <label for="Mqabastecido">Medicamentos Abastecidos </label>
            <input type="text" placeholder="Ingrese # de Medicamentos"  name="Mqabastecido" id="Mqabastecido" class="form-control" value="<?php echo $Mqabastecido; ?>">
            </div>


            <button type="submit" class="btn btn-danger"><i class="fas fa-user-edit"></i> Editar Hospital</button>
          </form>
        </div>
      </div>
    </div>
  </div>


</div>
<!-- /.container-fluid -->
<?php include_once "includes/footer.php"; ?>