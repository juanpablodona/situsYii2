<?php

use yii\helpers\Html;
use yii\helpers\Url;
use yii\web\View;

/* @var $this yii\web\View */
/* @var $model app\models\Charge */

$this->title = 'Eliminar Cobro';
$this->params['breadcrumbs'][] = ['label' => 'Contrato', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="charge-delete">

    <h1><?= Html::encode($this->title) ?></h1>

    <p> ¿Desea realmente eliminar el cobro?</p>

    
    <a href="javascript: deleteCharge(<?=$model->charge_id?>,<?=$model->contract_id?>)" class="btn btn-success">Si</a>
    

    <script>


        function deleteCharge(id, contractId) {
            $.ajax({
                url: '<?= Url::to(['charge/delete'])?>&id=' + id + '&ok=true',
                method: 'post',
                success: function (data) {
                    if (data === '1') {
                        $.ajax({
                            url: 'index.php?r=contract/view&id=' + contractId ,
                            method: 'post',
                            success: function (data2) {
                                
                                    $('.modal-body').empty();
                                    $('.modal-body').html(data2);
                                
                            }

                        });
                    }
                }

            });
        }





    </script>




</div>

