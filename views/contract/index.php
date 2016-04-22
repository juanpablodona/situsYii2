<?php

use yii\bootstrap\Modal;
use yii\data\ActiveDataProvider;
use yii\grid\GridView;
use yii\helpers\Html;
use yii\helpers\Url;
use yii\web\View;
use yii\widgets\Pjax;


/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Contratos';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="contract-index">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('Nuevo Contrato', ['create'], [
            'id' => 'newCon',
            'class' => 'btn btn-success',
            'data-toggle' => 'modal',
            'data-target' => '#modal',
            'data-url' => Url::to(['create']),
            'data-pjax' => '0',
        ]) ?>
    </p>
     <?php Pjax::begin() ?>
    <?=
    GridView::widget([
        'id'=> 'contract-grid',
        'dataProvider' => $dataProvider,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],
            'contract_id',
            'property_id',
            'number',
            'extended',
            'start_date',
            // 'finish_date',
            // 'amount',
            // 'status',
            // 'commission',
            // 'franchise_free',
            // 'daily_charge',
            // 'duration',
            [
                'class' => 'yii\grid\ActionColumn',
                'buttons' => [
                    'view' => function ($url, $model, $key) {
                        return Html::a('', '#', [
                                    'id' => 'viewCon',
                                    'class' => 'glyphicon glyphicon-eye-open',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-url' => Url::to(['view']) . '&id=' . $model->contract_id,
                                    'data-pjax' => '0',
                        ]);
                    },
                            'update' => function ($url, $model, $key) {
                        return Html::a('', '#', [
                                    'id' => 'updCon',
                                    'class' => 'glyphicon glyphicon-pencil',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-url' => Url::to(['update']) . '&id=' . $model->contract_id  ,
                                    'data-id' => $model->contract_id,
                                    'data-pjax' => '0',
                        ]);
                    },
                            'delete' => function ($url, $model, $key) {
                        return Html::a('', '#', [
                                    'id' => 'delCon',
                                    'class' => 'glyphicon glyphicon-trash',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-url' => Url::to(['delete']),
                                    'data-id' => $model->contract_id,
                                    'data-pjax' => '0',
                        ]);
                    },
                        ],
                    ]
                ],
            ]);
            ?>
             <?php Pjax::end() ?>
            <script>
                
                var ContractForm = new function () {
                    this.init = function () {
                        $(document).on('click', '#newCon', function () {
                            $.get(
                                    $(this).data('url'),
                                    function (data) {
                                        $('.modal-body').html(data);
                                        $('#modal').modal();
                            }
                        );
                            
                        });
                    };
                };

                var updateCon = new function () {
                    this.init = function () {
                        var id;
                        $(document).on('click', '#updCon', function () {
                            id = $(this).data('id');
                            $.get(
                                    $(this).data('url'),
                                    function (data) {
                                        $('.modal-body').html(data);
                                        $('#modal').modal();
                                    }
                            );
                            $(document).on("beforeSubmit", "form#contract-form", function (e)
                            {
                                var form = $(this);

                                $.ajax({
                                    url: "/situsYii2/web/index.php?r=contract%2Fupdate&id=" + id + "&submit=true",
                                    data: $("form#contract-form").serializeArray(),
                                    method: 'POST',
                                    success: function (result) {
                                        form.parent().html(result.message);
                                        $.pjax.reload({container: "#contract-grid"});
                                    },
                                    datatype: 'json'
                                });

                                return false;
                            });
                            $(document).on("submit", "form#contract-form", function (e) {
                                e.preventDefault();
                                e.stopImmediatePropagation();
                                return false;
                            });
                        });
                    };
                };

                var deleteCon = new function () {
                    this.init = function () {
                        $(document).on('click', '#delCon', function () {
                            $.ajax({
                                url: $(this).data('url') + '&id=' + $(this).data('id'),
                                method: 'post',
                                success:
                                        function (data) {
                                            $('.modal-body').html(data);
                                            $('#modal').modal();
                                        }
                            }
                            );

                        });
                    };

                };

                var viewCon = new function () {
                    this.init = function () {
                        $(document).on('click', '#viewCon', function () {

                            $.get(
                                    $(this).data('url'),
                                    function (data) {
                                        $('.modal-body').html(data);

                                        $('#modal').modal();
                                    }
                            );

                        });
                    };
                };



            </script>
            <?php
            $this->registerJs('ContractForm.init()');
            $this->registerJs('updateCon.init()');
            $this->registerJs('deleteCon.init()');
            $this->registerJs('viewCon.init()');
            ?>

            <?php
            Modal::begin([
                'id' => 'modal',
                'header' => '',
                'footer' => '',
                'size' => 'modal-lg'
            ]);

            echo "<div class='well'></div>";

            Modal::end();
            ?>
            
            
            ?>    
</div>
