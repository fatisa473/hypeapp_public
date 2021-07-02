<?php
    require_once 'basic_consults.php';
    $basic = new basic();

    $tipo_consulta = $_POST['tipo'];
    switch ($tipo_consulta) {
        case 'ingresar':
                $email = $_POST['email'];
                $password = $_POST['pass'];
                $select_usuario = $basic->getUsuario($email, $password);

                if($select_usuario) {
                    $select_tipo = $basic->getTipo_Usuario($select_usuario['idPerfil']);

                    //si select tipo es verdadero regresara como respuesta el nombre del tipo de usuario sino regresara el codigo del error ocasionado.
                    echo json_encode($select_tipo ? array("resp" => "success", "body" => $select_tipo["nombre"]) : array("resp" => "fail", "body" => "402")); 
                }else
                {
                    echo json_encode(array("resp" => "fail", "body" => "401"));
                }
            break;
        case 'registro':
               $select_emails = $basic->get_emails_iguales($_POST['email']);

                if($select_emails['cantidad'] == 0){
                    $data = array('nombres' => $_POST['nombres'], 'paterno' => $_POST['ap_pat'], 'materno' => $_POST['ap_mat'], 'email' => $_POST['email'], 'tel' => $_POST['tel'], 
                    'empresa' => $_POST['empresa'], 'password' => $_POST['password'], 'perfil' => $_POST['perfil'], 'nacionalidad' => $_POST['nacionalidad'], 'estatus' => 'Activo');
                    $result_insert_usuario = $basic->insert_new_usuario($data);
                    
                    echo json_encode($result_insert_usuario ? array("resp" =>"Success") : array("resp" => "fail", "body" => '492')); 
                }else{
                    echo json_encode(array("resp" => "fail", "body" => '495'));
                }
            break;
        case 'nacionalidades':
                $select_nacionalidades = $basic->get_Nacionalidades();   

                echo json_encode($select_nacionalidades ? array("resp" => "Success", "body" => $select_nacionalidades) : array("resp" => "fail", "body"=>'495'));
            break;
        case 'perfiles':
                $select_perfiles = $basic->get_Perfiles();

                echo json_encode($select_perfiles ? array("resp" => "Success", "body" => $select_perfiles) : array("resp" => "fail", "body"=>'495'));
            break;
        case 'visualizar informacion':
            $select_informacion = $basic->getInformacion($_POST['email']);

            echo json_encode($select_informacion ? $select_informacion : '495');
            break; 
        case 'revisar proveedor':
            $select_id = $basic->idUsuario($_POST['email']);
           if($select_id){
                $select_productos_servicios = $basic->getCountProductsServices_Supplier($select_id['idDato']);
                $select_notificaciones = $basic->getCountNotificaciones($select_id['idDato']);

               if($select_productos_servicios["cantidad_productos_servicios"] == 0 && $select_notificaciones["cantidad_notificaciones"] == 0){
                    echo json_encode(array("resp" => "success"));
                }else{
                    echo json_encode(array("resp" => "fail", "body" => "351"));
                }
            }else{
                echo json_encode(array("resp" => "fail", "body" => "495"));
            }
            break;
        case 'editar informacion':
            $data = array('nombres' => $_POST['nombres'], 'paterno' => $_POST['ap_pat'], 'materno' => $_POST['ap_mat'], 'email_nuevo' => $_POST['email_nuevo'], 'email_anterior' => $_POST["email_anterior"],
            'tel' => $_POST['tel'], 'empresa' => $_POST['empresa'],'nacionalidad' => $_POST['nacionalidad'], 'estatus' => $_POST['estatus']);

            $update_informacion = $basic->setInformacion($data);

            echo json_encode($update_informacion ? array("resp" => "success") : array("resp" => "fail", "body" => "495"));
            break;
        case 'editar password':
            $update_password = $basic->setPassword($_POST['pass_new'], $_POST['email']);

            echo json_encode($update_password ? array("resp" => "success") : array("resp" => "fail", "body" => "495"));
            break;
        default:
            echo json_encode(array("resp" => "fail", "body" => "495"));
            break;
    }
    //tipos de erorres
    // 401 - Usuario no encotrado
    // 402 - tipo no encontrado 
    // 492 - No ha sido posible registrar usuario
    // 495 - No se ha podido realizar la operacion
    // 351 - Existe actividad activa del usuario.
?>