<?php

use yii\helpers\Html;
use yii\helpers\Url;
use yii\web\View;


/* @var $this yii\web\View */
/* @var $model app\models\Property */

$this->title = 'Eliminar Propiedad';
$this->params['breadcrumbs'][] = ['label' => 'Property', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="property-delete">

    <h1><?= Html::encode($this->title) ?></h1>

    <p> Esta a punto de eliminar a  <?=$model->name?>. ¿Esta seguro de realizar
        esta accion?</p>
    
    <?php 
        echo yii\bootstrap\Html::a('Aceptar', '#', [
            'id' => 'aceptButton',
            'class' => 'btn btn-success',
            'data-url' => Url::to(['delete']). '&id='.$model->property_id.'&ok=TRUE',
            'data-pjax' => '0',]);
    
    ?>
    
    <script>
        var eliminaPropiedad= new function()
        {
            this.init = function (){
            $(document).on('click', '#aceptButton', function(e){
                $.ajax({
                    url: $(this).data('url'),
                    method: 'get',
                    success: function(data){
                        $(this).parent().html(data.message);
                        $.pjax.reload({container: "#property-grid"});
                    }            
                   
                });
            });
            
        };
    }
    
    </script>
    
    <?php 
        $this->registerJs('eliminaPropiedad.init()');
    ?>

</div>
