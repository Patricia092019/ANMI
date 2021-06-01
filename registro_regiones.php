<?php include_once "includes/header.php";
include "../conexion.php";
if (!empty($_POST)) {
    $alert = "";
    if (empty($_POST['Region']) || empty($_POST['mqprogramados']) || empty($_POST['Mqabastecido'])) {
        $alert = '<div class="alert alert-danger" role="alert">
                                    Todo los campos son obligatorio
                                </div>';
    } else {
        $region = $_POST['Region'];
        $mqprogramados = $_POST['mqprogramados'];
        $Mqabastecido = $_POST['Mqabastecido'];
        $abastecimiento = $Mqabastecido/$mqprogramados*100;
        

        $result = 0;
        if (is_numeric($dni) and $dni != 0) {
            $query = mysqli_query($conexion, "SELECT * FROM regiones where Region = '$region'");
            $result = mysqli_fetch_array($query);
        }
        if ($result > 0) {
            $alert = '<div class="alert alert-danger" role="alert">
                                    La Region ya existe
                                </div>';
        } else {
            $query_insert = mysqli_query($conexion, "INSERT INTO regiones (Region,mqprogramados,Mqabastecido,abastecimiento) values ('$region', '$mqprogramados', '$Mqabastecido', '$abastecimiento')");
            if ($query_insert) {
                $alert = '<div class="alert alert-primary" role="alert">
                                    Region Registrado
                                    
                                </div>';
                                ?>
                                <script>
                                window.location = "listar_regiones.php";
                                $.jGrowl("Componente agregado correctamente", { header: ' Region agregado' });
                                </script>
                                <?php
            } else {
                $alert = '<div class="alert alert-danger" role="alert">
                                    Error al Guardar
                            </div>';
            }
        }
    }
    mysqli_close($conexion);
}
?>

<!-- Begin Page Content -->
<div class="container-fluid">

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h3 class="text-black">Registro de Nueva Region </h3>
        <a href="listar_regiones.php" class="btn btn-primary">Regresar</a>
    </div>

    <!-- Content Row -->
    <div class="row">
        <div class="col-lg-6 m-auto">
            <div style="background-color:#DCDCDC"  class="card">
                <div class="card-header bg-info">
                    Nueva Region
                </div>
                <div class="card-body">
                    <form action="" method="post" autocomplete="off">
                        <?php echo isset($alert) ? $alert : ''; ?>
                        <div class="form-group">
                            <label for="nombre">Nombre de Region </label>
                            <input type="text" placeholder="Ingrese Nombre" name="Region" id="Region" class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="mq">Medicamentos Programados </label>
                            <input type="text" placeholder="Ingrese # de Medicamentos " name="mqprogramados" id="mqprogramados" class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="Ma">Medicamentos Abastecidos </label>
                            <input type="text" placeholder="Ingrese # de Medicamentos "  name="Mqabastecido" id="Mqabastecido" class="form-control">
                        </div>
                        
                        <input type="submit" value="Guardar Region" class="btn btn-primary">
                    </form>
                </div>
            </div>
        </div>
    </div>


</div>
<!-- /.container-fluid -->
<?php include_once "includes/footer.php"; ?>