<?php include_once "includes/header.php";
include "../conexion.php";
if (!empty($_POST)) {
    $alert = "";
    if (empty($_POST['fecha']) || empty($_POST['cantidad']) || empty($_POST['medicamento'])) {
        $alert = '<div class="alert alert-danger" role="alert">
                                    Todo los campos son obligatorio
                                </div>';
    } else {
        $fecha = $_POST['fecha'];
        $hora = $_POST['hora'];
        $lab = $_POST['laboratorio'];
        $referencia = $_POST['referencia'];
        $mq = $_POST['medicamento'];
        $cantidad = $_POST['cantidad'];
        $bodega = $_POST['bodega'];
        $observaciones = $_POST['observaciones'];
        
   
        $result = 0;
        if (is_numeric($cantidad) and $cantidad != 0) {
            $query = mysqli_query($conexion, "SELECT * FROM citas where fecha = '$fecha' and hora='$hora'");
            $result = mysqli_fetch_array($query);
        }
        if ($result > 0) {
            $alert = '<div class="alert alert-danger" role="alert">
                                    Cita ya existe ya existe
                                </div>';
        } else {
            $query_insert = mysqli_query($conexion, "INSERT INTO  (fecha,hora,laboratorio, referencia,medicamento,cantidad,bodega, observaciones) values ('$fecha', '$hora', '$lab', '$referencia','$mq','$canidad','$bodega,'$observaciones')");
            if ($query_insert) {
                $alert = '<div class="alert alert-primary" role="alert">
                                   Cita Registrada
                                    
                                </div>';
                                ?>
                                <script>
                                window.location = "listar_citas.php";
                                $.jGrowl("Componente agregado correctamente", { header: 'cita agregado' });
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
        <h3 class="text-black">Registro de Nueva Cita</h3>
        <a href="listar_citas.php" class="btn btn-primary">Regresar</a>
    </div>

    <!-- Content Row -->
    <div class="row">
     <div class="col-lg-6" >
            <div  class="card" style="width: 180% !important;">
                <div class="card-header bg-info">
                    Nueva Cita Programada 
                </div>
                <div class="form-row" >
                    <form action="" method="post" autocomplete="off">
                        <?php echo isset($alert) ? $alert : ''; ?>
                        <div class="row">
                        <div class="col-3 col-sm-4">
                            <label for="nombre">  Fecha</label>
                            <input type="date" placeholder="Ingrese la fecha" name="fecha" id="fecha " class="form-control">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="hora">  Hora </label>
                            <input type="time" placeholder="Ingrese hora " name="hora" id="hora" class="form-control">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="Lab">Laboratorio </label>
                            <input type="text" placeholder="Ingrese Nombre del Proveedor "  name="lab" id="lab" class="form-control">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="Lic">Licitacion </label>
                            <input type="text" placeholder="Ingrese # de Licitacion  "  name="referencia" id="referencia" class="form-control">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="mq">Medicamento</label>
                            <input type="text" placeholder="Ingrese Nombre de medicamento"  name="mq" id="mq" class="form-control">
                        </div>
                        <div class="col">
                            <label for="cd">Codigo</label>
                            <input type="text"  name="cd" id="cd" class="form-control" readonly>
                        </div>
                        <div class="col-auto my-1">
                         <button type="submit" class="btn btn-primary">Buscar</button>
                           </div>
                           <div class="form-group col-md-6">
                            <label for="cantidad">Cantidad</label>
                            <input type="text" placeholder="Ingrese cantidad"  name="cantidad" id="cantidad" class="form-control">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="bodega">Bodega</label>
                            <input type="text" placeholder="Ingrese Bodega"  name="bodega" id="bodega" class="form-control">
                        </div>

                        <div class="form-group col-md-6">
                            <label for="Observacion">Observaciones</label>
                            <input type="text" placeholder="Ingrese observaciones"  name="observaciones" id="observaciones" class="form-control">
                        </div>
                        <div class="form-group col-md-6">
                        <input type="submit" value="Guardar" class="btn btn-success">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>


</div>
<!-- /.container-fluid -->
<?php include_once "includes/footer.php"; ?>