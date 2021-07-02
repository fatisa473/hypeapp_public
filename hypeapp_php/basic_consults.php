<?php
    class basic{
        private $bd;
        public function __construct(){
            require_once 'conexion.php';
            $this->bd = conexion::conectar();
        }

        //un resultado
        public function getUsuario($email, $pass){
            //FALTA CONVERTIR EL PASSWORD A HASH
            $consulta = $this->bd->prepare("SELECT idPerfil FROM datos WHERE email = :correo AND pass = :contra AND (estatus = 'Activo' OR estatus = 'Pausado')");

            $consulta->bindParam(":correo",$email);
            $consulta->bindParam(":contra",$pass);
            $consulta->execute();
            
            if(!empty($consulta))
            {
                $fila = $consulta->fetch(PDO::FETCH_ASSOC);
                return $fila;
            }
            return false;
        }

        //un resultado
        public function getTipo_Usuario($id_tipo){
            $consulta = $this->bd->prepare("SELECT nombre FROM perfiles WHERE idPerfil = :tipo");

            $consulta->bindParam(":tipo",$id_tipo);
            $consulta->execute();
            
            if(!empty($consulta))
            {
                $fila = $consulta->fetch(PDO::FETCH_ASSOC);
                return $fila;
            }
            return false;
        }

        public function insert_new_usuario($data){
            $password_encriptado = password_hash($data['password'], PASSWORD_DEFAULT);
            $consulta = $this->bd->prepare("INSERT INTO datos (idNacionalidad, idPerfil, nombres, ap_pat, ap_mat, email, tel, 
            empresa, pass, estatus) VALUES (:nacionalidad,:perfil,:nombres,:paterno,:materno,:email ,:tel,:empresa, :pass, :estatus)");

            $consulta->bindParam(":nacionalidad", $data['nacionalidad']);
            $consulta->bindParam(":perfil", $data['perfil']);
            $consulta->bindParam(":nombres", $data['nombres']);
            $consulta->bindParam(":paterno", $data['paterno']);
            $consulta->bindParam(":materno", $data['materno']);
            $consulta->bindParam(":email", $data['email']);
            $consulta->bindParam(":tel", $data['tel']);
            $consulta->bindParam(":empresa", $data['empresa']);
            $consulta->bindParam(":pass", $password_encriptado);
            $consulta->bindParam(":estatus", $data['estatus']);
            $consulta->execute();
            
            if(!empty($consulta))
            {
                return true;
            }
            return false;
        }

        public function get_Nacionalidades(){
            $consulta = $this->bd->prepare("SELECT idNacionalidad,nombre FROM nacionalidades");
            $consulta->execute();
            
            if(!empty($consulta))
            {
                while($fila = $consulta->fetch(PDO::FETCH_ASSOC)){
                    $resultado[$fila["idNacionalidad"]] = $fila["nombre"];
                }
                return $resultado;
            }
            return false;
        }
        public function get_Perfiles(){
            $consulta = $this->bd->prepare("SELECT idPerfil,nombre FROM perfiles");
            $consulta->execute();
            
            if(!empty($consulta))
            {
                while($fila = $consulta->fetch(PDO::FETCH_ASSOC)){
                    $resultado[$fila["idPerfil"]] = $fila["nombre"];
                }
                return $resultado;
            }
            return false;
        }
        public function get_emails_iguales($correo){
            $consulta = $this->bd->prepare("SELECT COUNT(idDato) AS cantidad FROM datos WHERE email = :correo");
            $consulta->bindParam(":correo", $correo);
            $consulta->execute();
            
            return $resultado = $consulta->fetch(PDO::FETCH_ASSOC);
        }

        //SELECT - UN RESULTADO
        public function getInformacion($email){
            $consulta = $this->bd->prepare("SELECT idDato, nombres, ap_pat, ap_mat, email, tel, empresa, idNacionalidad, estatus FROM datos WHERE email = :correo");

            $consulta->bindParam(":correo",$email);
            $consulta->execute();
            
            if(!empty($consulta))
            {
                $fila = $consulta->fetch(PDO::FETCH_ASSOC);
                return $fila;
            }
            return false;
        }
        
        //UPDATE - INFORMATION
        public function setInformacion($data){
            $consulta = $this->bd->prepare("UPDATE datos SET idNacionalidad = :nacionalidad, nombres = :nombres, ap_pat = :paterno, ap_mat = :materno, 
            email = :email_nuevo, tel = :tel, empresa = :empresa, estatus = :estatus WHERE email = :email_anterior");

            
            $consulta->bindParam(":email_anterior", $data['email_anterior']);
            $consulta->bindParam(":nacionalidad", $data['nacionalidad']);
            $consulta->bindParam(":nombres", $data['nombres']);
            $consulta->bindParam(":paterno", $data['paterno']);
            $consulta->bindParam(":materno", $data['materno']);
            $consulta->bindParam(":email_nuevo", $data['email_nuevo']);
            $consulta->bindParam(":tel", $data['tel']);
            $consulta->bindParam(":empresa", $data['empresa']);
            $consulta->bindParam(":estatus", $data['estatus']);
            $consulta->execute();
            
            if(!empty($consulta))
            {
                return true;
            }
            return false;
        }

        //UPDATE - INFORMACION - PASSWORD
        public function setPassword($password, $email){
            $password_encriptado = password_hash($password, PASSWORD_DEFAULT);
            $consulta = $this->bd->prepare("UPDATE datos SET pass = :pass WHERE email = :email");
            
            $consulta->bindParam(":email", $email);
            $consulta->bindParam(":pass", $password_encriptado);
            $consulta->execute();
            
            if(!empty($consulta))
            {
                return true;
            }
            return false;
        }

        public function idUsuario($email){
            $consulta = $this->bd->prepare("SELECT idDato FROM datos WHERE email = :correo");

            $consulta->bindParam(":correo",$email);
            $consulta->execute();
            
            if(!empty($consulta))
            {
                $fila = $consulta->fetch(PDO::FETCH_ASSOC);
                return $fila;
            }
            return false;
        }

        //COUNT productos y servicios
        public function getCountProductsServices_Supplier($id){
            $consulta = $this->bd->prepare("SELECT COUNT(idProducto_Servicio) AS cantidad_productos_servicios FROM productos_servicios WHERE idDato = :id AND estatus = 'Activo'");
            $consulta->bindParam(":id", $id);
            $consulta->execute();
            
            return $resultado = $consulta->fetch(PDO::FETCH_ASSOC);
        }

        //COUNT notificaciones
        public function getCountNotificaciones($id){
            $consulta = $this->bd->prepare("SELECT COUNT(idDato) AS cantidad_notificaciones FROM notificaciones WHERE idDato = :id AND estatus = 'Activo'");
            $consulta->bindParam(":id", $id);
            $consulta->execute();
            
            return $resultado = $consulta->fetch(PDO::FETCH_ASSOC);
        }        
        

        public function cerrar_conexion(){
            $this->bd->close();
        }
    }


?>