<?php include_once "includes/header.php"; ?>

<div class="container-fluid">
    <div class="row">
        <div class="col-lg-12">
            <div class="form-group">
                <h4 class="text-center">Datos de Citas </h4>
                <a href="#" class="btn btn-primary btn_new_cita"><i class="fas fa-user-plus"></i> Nuevo Cita</a>
            </div>
            <div class="card">
                <div class="card-body">
                    <form method="post" name="form_new_cita" id="form_new_cita">
                        <input type="hidden" name="action" value="addcita">
                        <input type="hidden" id="Id" value="1" name="Id" required>
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="form-group">
                                <label for="nombre">  Fecha</label>
                            <input type="date" name="fecha" id="fecha " class="form-control" >
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="form-group">
                                <label for="hora">  Hora </label>
                                <input type="time" name="hora" id="hora" class="form-control" disabled  required>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="form-group">
                                    <label>Licitacion</label>
                                    <input type="text" name="referencia" id="referencia" class="form-control" disabled required>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="form-group">
                                    <label>Laboratorio </label>
                                    <input type="text" name="laboratorio" id="laboratorio" class="form-control" disabled  required>
                                </div>

                            </div>
                            <div class="col-lg-4">
                                <div class="form-group">
                          <label for="bodega">Bodega de Recepcion</label>
                         <select class="form-control" id="bodega" name="bodega" disabled required >
                                 <option value="COALSA">COALSA</option>
                                 <option value="ANMI/SESAL">ANMI/SESAL</option>
                         </select>
                         </div>
                            </div>
                            </div>
                            <div id="div_registro_cita" style="display: none;">
                                <button type="submit" class="btn btn-primary">Guardar</button>
                            </div>
                        
                        </div>
                    </form>
                </div>
            </div>
            <div class="card">
                <div class="card-body">       
                </div>
                <div class="col-lg-6">
                    <div class="form-group">
                        <label><i class="fas fa-user"></i> USUARIO</label>
                        <p style="font-size: 16px; text-transform: uppercase; color: red;"><?php echo $_SESSION['nombre']; ?></p>
                    </div>
                </div>
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="thead-dark">
                        <tr>
                            <th width="100px">Mediacemento</th>
                            <th width="100px">            </th>
                            <th width="100px"> Codigo </th>
                            <th width="100px">Cantidad</th>
                            <th width="100px" class="textright">Observaciones </th>
                            <th>Acciones</th>
                        </tr>
                        <tr>
                            <td><input type="hidden" name="id" id="id">
                                <input type="text" name="nombre" id="nombre">

                            </td>
                            <td> <div class="col-3 col-sm-1">
                          <a data-toggle="modal" href="#myModa1">           
                          <h1 class="form-group col-3 col-sm-3"> <button id="btnAgregarcli" type="button" class="btn btn-success"> <span class="fa fa-plus"></span></button></h1>
                            </a> 
                            </div>  </td>
                            <td><input type="text" id="codigo"></td>
                            <td> <input type="text"id="unidades"></td>
                            <td><input type="text" name="observaciones" id="observaciones" ></td>
                        </tr>
                
                    </thead>
                   
                </table>

            </div>
        </div>
    </div>

</div>
<!-- /.container-fluid -->
 <!-- Modal -->
 <div class="modal fade" id="myModa1"  tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" >
    <div class="modal-dialog" style="width: 70% !important;">
      <div style ="background: #f0f0f2" class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
          <h4 class="modal-title">Seleccione el Medicamento agregar </h4>
        </div>
        <div style ="background: #f0f0f2" class="modal-body">
          <table id="tblmq" class="table table-hover">
            <thead style="background-color:#0e4f91" class="table-dark">
                <th>Agregar</th>
                <th>ID</th>
                <th>Nombre</th>
                <th>Codigo</TH>
                <th>Presentacion </th>
            </thead>
          </table>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
        </div>        
      </div>
    </div>
  </div>  
  
  <script type="text/javascript" src="js/medicamentos.js"></script>

<?php include_once "includes/footer.php"; ?>