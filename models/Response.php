<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace app\models;

/**
 * Description of Response
 *
 * @author juan
 */
class Response {
   
    
    
    public static function createSuccessResponse($message=null, $html=null, $data=null){
        return [
          'status' => 'ok',
          'message'=> $message,
          'html' => $html,
          'data'=> $data            
        ];
        
    }
    
    public static function createErrorResponse($message=null, $html=null, $data=null){
        return [
          'status' => 'fail',
          'message'=> $message,
          'html' => $html,
          'data'=> $data            
        ];
        
    }
}
