<?php
    class conexion{
        public static function conectar(){
            try{
                $conexion = new PDO('mysql:host=localhost;dbname=hypeapp','root','');
                $conexion->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
                $conexion->exec('SET CHARACTER SET UTF8');
            }catch(Exception $e){
                die('ERROR '. $e->getMessage());
                echo 'Linea del error '. $e->getLine();
            }
            return $conexion;
        }
    }

?>