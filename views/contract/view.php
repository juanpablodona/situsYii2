<?php

use yii\helpers\Html;
use yii\widgets\DetailView;
use yii\bootstrap\Modal;
use yii\data\ActiveDataProvider;
use yii\helpers\Url;
use yii\web\View;
use yii\widgets\Pjax;

/* @var $this yii\web\View */
/* @var $model app\models\Contract */

$this->title = $model->number . ' - ' . $model->property->street . ' ' . $model->property->street_number;
$this->params['breadcrumbs'][] = ['label' => 'Contracts', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="contract-view">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('Update', ['update', 'id' => $model->contract_id], ['class' => 'btn btn-primary']) ?>
        <?=
        Html::a('Delete', ['delete', 'id' => $model->contract_id], [
            'class' => 'btn btn-danger',
            'data' => [
                'confirm' => 'Are you sure you want to delete this item?',
                'method' => 'post',
            ],
        ])
        ?>
        <a href="javascript: chargeButtonEvent(<?= $model->contract_id ?>)" id="charge" class="btn btn-success">Cobrar</a>
        <?= Html::a('Exportar', ['update', 'id' => $model->contract_id], ['class' => 'btn btn-primary']) ?>

    </p>

    <?=
    DetailView::widget([
        'model' => $model,
        'attributes' => [
            'contract_id',
            'property_id',
            'number',
            'extended',
            'start_date',
            'finish_date',
            'amount',
            'status',
            'commission',
            'franchise_free',
            'daily_charge',
            'duration',
        ],
    ])
    ?>
    <h3>Cobros Registrados</h3>
    <?php Pjax::begin() ?>
    <?=
    yii\grid\GridView::widget([
        'dataProvider' => $charges,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],
            'charged_period',
            'expiration',
            'charge_mount',
            [
                'class' => 'yii\grid\ActionColumn',
                'buttons' => [
                    'view' => function ($url, $charges, $key) {
                        return '<a href="javascript: viewChargeButtonEvent(' .
                                $charges->charge_id . ')" id="viewCharge" '
                                . 'class="glyphicon glyphicon-eye-open"></a>';
                    },
                    'update' => function ($url, $charges, $key) {
                        return '<a href="javascript: updateChargeButtonEvent(' .
                                $charges->charge_id . ',' . $charges->contract_id . ')" id="updCharge" '
                                . 'class="glyphicon glyphicon-pencil", data-url="'.Url::to(['charge/update']).'"></a>';
                    },
                    'delete' => function ($url, $charges, $key) {
                        return '<a href="javascript: delChargeButtonEvent(' .
                                $charges->charge_id .')" id="delCharge" '
                                . 'class="glyphicon glyphicon-trash"></a>';
                    },
                        ],
                    ]
                ],
            ]);
            ?>
            <?php Pjax::end() ?>
    
    <h3>Pagos Registrados</h3>
    <?php Pjax::begin() ?>
    <?=
    yii\grid\GridView::widget([
        'dataProvider' => $payments,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],
            'payment_period',
            'payment_date',
            'payment_mount',
            [
                'class' => 'yii\grid\ActionColumn',
                'buttons' => [
                    'view' => function ($url, $payments, $key) {
                        return '<a href="javascript: viewPayButtonEvent(' .
                                $payments->payment_id . ')" id="viewPayment" '
                                . 'class="glyphicon glyphicon-eye-open"></a>';
                    },
                    'update' => function ($url, $payments, $key) {
                        return '<a href="javascript: updatePayButtonEvent(' .
                                $payments->payment_id . ',' . $payments->contract_id . ')" id="updPayment" '
                                . 'class="glyphicon glyphicon-pencil", data-url="'.Url::to(['payment/update']).'"></a>';
                    },
                    'delete' => function ($url, $payments, $key) {
                        return '<a href="javascript: delPayButtonEvent(' .
                                $payments->payment_id .')" id="delPayment" '
                                . 'class="glyphicon glyphicon-trash"></a>';
                    },
                        ],
                    ]
                ],
            ]);
            ?>
            <?php Pjax::end() ?>
    
    <script>

        function chargeButtonEvent(id) {
            $.ajax({
                url: '<?= Url::to(['charge/create'])?>'+'&contract_id=' + id,
                method: 'post',
                success: function (data) {
                    $('.modal-body').empty();
                    $('.modal-body').html(data);
                    $(document).on("beforeSubmit", "form#charge-form", function (e)
                    {
                        var form = $(this);

                        $.ajax({
                            url:'<?= Url::to(['charge/create'])?>'+'&submit=true&contract_id=' + id,
                            data: $("form#charge-form").serializeArray(),
                            method: 'POST',
                            success: function (result) {

                                if (result === '1') {
                                    $.ajax({
                                        url: '<?= Url::to(['contract/view'])?>' + '&id=' + id,
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
                    $(document).on("submit", "form#charge-form", function (e) {
                        e.preventDefault();
                        e.stopImmediatePropagation();
                        return false;
                    });

                }
            }
            );
        }


        function viewChargeButtonEvent(id) {
            $.ajax({
                    url:'index.php?r=charge/view&id='+ id,
                    method: 'post',
                    success: function (data) {
                        $('.modal-body').html(data);

                        $('#modal').modal();
                    }
                });
        }


        function viewPayButtonEvent(id) {
            $.get(
                    '<?= Url::to(['payment/view'])?>'+'&id=' + id,
                    function (data) {
                        $('.modal-body').html(data);

                        $('#modal').modal();
                    }
            );
        }



        function updateChargeButtonEvent(id, contractId) {
            $.ajax({
                url: $('#updCharge').data('url')+'&id=' + id,
                method: 'post',
                success: function (data) {
                    $('.modal-body').empty();
                    $('.modal-body').html(data);

                    $(document).on("beforeSubmit", "form#charge-form", function (e)
                    {
                        var form = $(this);

                        $.ajax({
                            url: '<?= Url::to(['charge/update'])?>'+'&id=' + id + '&submit=true',
                            data: $("form#charge-form").serializeArray(),
                            method: 'POST',
                            success: function (result) {

                                if (result === '1') {
                                    $.ajax({
                                        url: 'index.php?r=contract/view&id='+ contractId,
                                        method: 'post',
                                        success: function (data2) {
                                            $('.modal-body').empty();
                                            $('.modal-body').html(data2);
                                        }
                                    });

                                }
                            },
                        });
                        return false;
                    });
                    $(document).on("submit", "form#charge-form", function (e) {
                        e.preventDefault();
                        e.stopImmediatePropagation();
                        return false;
                    });


                }});
        }

        
        function updatePayButtonEvent(id, contractId) {
            $.ajax({
                url: '<?= Url::to(['payment/update'])?>'+'&id=' + id,
                method: 'post',
                success: function (data) {
                    $('.modal-body').empty();
                    $('.modal-body').html(data);

                    $(document).on("beforeSubmit", "form#payment-form", function (e)
                    {
                        var form = $(this);

                        $.ajax({
                            url: '<?= Url::to(['payment/update'])?>'+'&id=' + id + '&submit=true',
                            data: $("form#payment-form").serializeArray(),
                            method: 'POST',
                            success: function (result) {

                                if (result === '1') {
                                    $.ajax({
                                        url: 'index.php?r=contract/view&id='+ contractId,
                                        method: 'post',
                                        success: function (data2) {
                                            $('.modal-body').empty();
                                            $('.modal-body').html(data2);
                                        }
                                    });

                                }
                            },
                        });
                        return false;
                    });
                    $(document).on("submit", "form#payment-form", function (e) {
                        e.preventDefault();
                        e.stopImmediatePropagation();
                        return false;
                    });


                }});
        }



        function delChargeButtonEvent(id) {
            $.ajax({
                url: '<?= Url::to(['charge/delete'])?>'+'&id=' + id,
                method: 'post',
                success: function (data) {
                    $('.modal-body').html(data);
                    $('#modal').modal();
                }
            });
        }

        function delPayButtonEvent(id) {
            $.ajax({
                url: '<?= Url::to(['payment/delete'])?>'+'&id=' + id,
                method: 'post',
                success: function (data) {
                    $('.modal-body').html(data);
                    $('#modal').modal();
                }
            });
        }








    </script>



</div>
