<?php

use yii\helpers\Html;
use yii\helpers\Url;
use yii\web\View;

/* @var $this yii\web\View */
/* @var $model app\models\Payment */

$this->title = 'Eliminar Pago';
$this->params['breadcrumbs'][] = ['label' => 'Contrato', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="payment-delete">

    <h1><?= Html::encode($this->title) ?></h1>

    <p> ¿Desea realmente eliminar el cobro?</p>

    
    <a href="javascript: deletePayment(<?=$model->payment_id?>,<?=$model->payment_id?>)" class="btn btn-success">Si</a>
    

    <script>


        function deletePayment(id, contractId) {
            $.ajax({
                url: '<?= Url::to(['payment/delete'])?>&id=' + id + '&ok=true',
                method: 'post',
                success: function (data) {
                    if (data === '1') {
                        $.ajax({
                            url: '<?= Url::to(['contract/view'])?>'&id=' + contractId ,
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