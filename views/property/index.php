<?php

use yii\bootstrap\Modal;
use yii\data\ActiveDataProvider;
use yii\grid\GridView;
use yii\helpers\Html;
use yii\helpers\Url;
use yii\web\View;
use yii\widgets\Pjax;

/* @var $this View */
/* @var $dataProvider ActiveDataProvider */

$this->title = 'Propiedades';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="property-index">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?php Pjax::begin() ?>
        <?=
        Html::a('Nueva Propiedad', ['create'], [
            'class' => 'btn btn-success',
            'id' => 'newProp',
            'data-toggle' => 'modal',
            'data-target' => '#modal',
            'data-url' => Url::to(['create']),
            'data-pjax' => '0',
        ])
        ?>
    </p>
    <?=
    GridView::widget([
        'id' => 'property-grid',
        'dataProvider' => $dataProvider,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],
            'name',
            'street',
            'street_number',
            //'zip_code',
            'description',
            // 'name',
            'locality_id',
            // 'designation',
            [
                'class' => 'yii\grid\ActionColumn',
                'buttons' => [
                    'view' => function ($url, $model, $key) {
                        return Html::a('', '#', [
                                    'id' => 'viewProp',
                                    'class' => 'glyphicon glyphicon-eye-open',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-url' => Url::to(['view']) . '&id=' . $model->property_id,
                                    'data-pjax' => '0',
                        ]);
                    },
                            'update' => function ($url, $model, $key) {
                        return Html::a('', '#', [
                                    'id' => 'updProp',
                                    'class' => 'glyphicon glyphicon-pencil',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-url' => Url::to(['update']) . '&id=' . $model->property_id,
                                    'data-id' =>$model->property_id,
                                    'data-pjax' => '0',
                        ]);
                    },
                            'delete' => function ($url, $model, $key) {
                        return Html::a('', '#', [
                                    'id' => 'delProp',
                                    'class' => 'glyphicon glyphicon-trash',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-url' => Url::to(['delete']), 
                                    'data-id' =>$model->property_id,
                                    'data-pjax' => '0',
                        ]);
                    },
                        ],
                    ],
        ],
    ]);
    ?>
    <?php Pjax::end() ?>

    <script>
        var PropertyForm = new function () {
            this.init = function () {
                $(document).on('click', '#newProp', function () {
                    $.get(
                            $(this).data('url'),
                            function (data) {
                                $('.modal-body').html(data);
                                $('#modal').modal();
                            }
                    );
                    $(document).on("beforeSubmit", "form#property-form", function (e)
                    {
                        var form = $(this);

                        $.ajax({
                            url: "/situsYii2/web/index.php?r=property%2Fcreate&submit=true",
                            data: $("form#property-form").serializeArray(),
                            method: 'POST',
                            success: function (result) {
                                form.parent().html(result.message);
                                $.pjax.reload({container: "#property-grid"});
                            },
                            datatype: 'json'
                        });

                        return false;
                    });
                    $(document).on("submit", "form#property-form", function (e) {
                        e.preventDefault();
                        e.stopImmediatePropagation();
                        return false;
                    });
                });
            };
        };

        var updateProp = new function () {
            this.init = function () {
                var id;
                $(document).on('click', '#updProp', function () {
                    id = $(this).data('id');
                    $.get(
                            $(this).data('url'),
                            function (data) {
                                $('.modal-body').html(data);
                                $('#modal').modal();
                            }
                    );
                    $(document).on("beforeSubmit", "form#property-form", function (e)
                    {
                        var form = $(this);

                        $.ajax({
                            url: "/situsYii2/web/index.php?r=property%2Fupdate&id=" + id + "&submit=true",
                            data: $("form#person-form").serializeArray(),
                            method: 'POST',
                            success: function (result) {
                                form.parent().html(result.message);
                                $.pjax.reload({container: "#property-grid"});
                            },
                            datatype: 'json'
                        });

                        return false;
                    });
                    $(document).on("submit", "form#property-form", function (e) {
                        e.preventDefault();
                        e.stopImmediatePropagation();
                        return false;
                    });
                });
            };
        };

        var deleteProp = new function () {
            this.init = function () {
                $(document).on('click', '#delProp', function () {
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

        var viewProp = new function () {
            this.init = function () {
                $(document).on('click', '#viewProp', function () {

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
            $this->registerJs('PropertyForm.init()');
            $this->registerJs('updateProp.init()');
            $this->registerJs('deleteProp.init()');
            $this->registerJs('viewProp.init()');
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
</div>
