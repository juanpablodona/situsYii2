<?php

use yii\helpers\Html;
use yii\helpers\Url;
use yii\web\View;


/* @var $this yii\web\View */
/* @var $model app\models\Contract */

$this->title = 'Eliminar Contrato';
$this->params['breadcrumbs'][] = ['label' => 'Contrato', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="contract-delete">

    <h1><?= Html::encode($this->title) ?></h1>

    <p> Esta a punto de eliminar el contrato  <?=$model->number  ?>. ¿Esta seguro de realizar
        esta accion?</p>
    
    <?php 
        echo yii\bootstrap\Html::a('Aceptar', '#', [
            'id' => 'aceptButton',
            'class' => 'btn btn-success',
            'data-url' => Url::to(['delete']). '&id='.$model->contract_id.'&ok=TRUE',
            'data-pjax' => '0',]);
    
    ?>
    
    <script>
        var eliminaContract= new function()
        {
            this.init = function (){
            $(document).on('click', '#aceptButton', function(e){
                $.ajax({
                    url: $(this).data('url'),
                    method: 'post',
                    success: function(data){
                        $(this).parent().html(data.message);
                        $.pjax.reload({container: "#contract-grid"});
                    }            
                   
                });
            });
            
        };
    }
    
    </script>
    
    <?php 
        $this->registerJs('eliminaContract.init()');
    ?>


</div>


