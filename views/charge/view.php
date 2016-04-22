<?php

use app\models\Charge;
use app\models\Contract;
use app\models\Property;
use yii\helpers\Html;
use yii\helpers\Url;
use yii\web\View;
use yii\widgets\DetailView;

/* @var $this View */
/* @var $model Charge */

$contract= Contract::findOne($model->contract_id);
$property= app\models\Property::findOne($contract->property_id);
$this->title = $property->name . ' - ' . $property->street . ' ' .$property->street_number . '-'. $model->charged_period;
$this->params['breadcrumbs'][] = ['label' => 'Charges', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="charge-view">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('Update', ['update', 'id' => $model->charge_id], ['class' => 'btn btn-primary']) ?>
        <?= Html::a('Delete', ['delete', 'id' => $model->charge_id], [
            'class' => 'btn btn-danger',
            'data' => [
                'confirm' => 'Are you sure you want to delete this item?',
                'method' => 'post',
            ],
        ]) ?>
        <a href="javascript: paymentButtonEvent(<?=$model->charge_id?>)" class="btn btn-success">Realizar Pago</a>
    </p>

    <?= DetailView::widget([
        'model' => $model,
        'attributes' => [
            'charge_id',
            'contract_id',
            'charge_date',
            'charge_mount',
            'charged_period',
            'municipality',
            'water_service',
            'expenses',
            'comment',
            'expiration',
            'recharge',
            'deductions',
            'other_recharge',
            'charge_words',
        ],
    ]) ?>
    
    <script>
        function paymentButtonEvent(id) {
            $.ajax({
                url: '<?= Url::to(['payment/create'])?>'+'&charge_id=' + id,
                method: 'post',
                success: function (data) {
                    $('.modal-body').empty();
                    $('.modal-body').html(data);
                    $(document).on("beforeSubmit", "form#payment-form", function (e)
                    {
                        var form = $(this);

                        $.ajax({
                            url:'<?= Url::to(['payment/create'])?>'+'&submit=true&charge_id=' + id,
                            data: $("form#payment-form").serializeArray(),
                            method: 'POST',
                            success: function (result) {

                                if (result === '1') {
                                    $.ajax({
                                        url: '<?= Url::to(['contract/view'])?>'+'&id=' + id,
                                        method: 'post',
                                        success: function (data2) {
                                            $('.modal-body').empty();
                                            $('.modal-body').html(data2);
                                        },
                                    });

                                }
                            },
                            datatype: 'json'

                        });
                        return false;
                    });
                    $(document).on("submit", "form#payment-form", function (e) {
                        e.preventDefault();
                        e.stopImmediatePropagation();
                        return false;
                    });

                }
            }
            );
        }
    </script>

</div>
