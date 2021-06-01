<?php
if (!empty($_GET['id'])) {
    require("../conexion.php");
    $id = $_GET['id'];
    $query_delete = mysqli_query($conexion, "DELETE FROM regiones WHERE id_region = $id");
    mysqli_close($conexion);
    header("location: listar_regiones.php");
}
?>