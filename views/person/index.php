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

$this->title = 'Personas';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="person-index">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?=
        Html::a('Nueva Persona', '#', [
            'id' => 'newPer',
            'class' => 'btn btn-success',
            'data-toggle' => 'modal',
            'data-target' => '#modal',
            'data-url' => Url::to(['create']),
            'data-pjax' => '0',
        ])
        ?>
    </p>
    <?php Pjax::begin() ?>
    <?=
    GridView::widget([
        'id' => 'person-grid',
        'dataProvider' => $dataProvider,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],
            //'person_id',
            'name',
            'first_surname',
            'document_type',
            'document_number',
            // 'second_surname',
            // 'street',
            // 'street_number',
            // 'phone',
            // 'mobile',
            // 'employee',
            // 'job_adress',
            'profession',
            // 'civil_status',
            // 'salary',
            // 'commercial_references',
            // 'bank_references',
            // 'zip_code',
            // 'bank',
            // 'bank_number',
            // 'bank_holder',
            // 'bank_branch',
            // 'locality_id',
            // 'type',
            // 'owner',
            // 'cuit',
            [
                'class' => 'yii\grid\ActionColumn',
                'buttons' => [
                    'view' => function ($url, $model, $key) {
                        return Html::a('', '#', [
                                    'id' => 'viewPer',
                                    'class' => 'glyphicon glyphicon-eye-open',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-url' => Url::to(['view']) . '&id=' . $model->person_id,
                                    'data-pjax' => '0',
                        ]);
                    },
                            'update' => function ($url, $model, $key) {
                        return Html::a('', '#', [
                                    'id' => 'updPer',
                                    'class' => 'glyphicon glyphicon-pencil',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-url' => Url::to(['update']) . '&id=' . $model->person_id,
                                    'data-id' =>$model->person_id,
                                    'data-pjax' => '0',
                        ]);
                    },
                            'delete' => function ($url, $model, $key) {
                        return Html::a('', '#', [
                                    'id' => 'delPer',
                                    'class' => 'glyphicon glyphicon-trash',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-url' => Url::to(['delete']), 
                                    'data-id' =>$model->person_id,
                                    'data-pjax' => '0',
                        ]);
                    },
                        ],
                    ]
                ]
            ]);
            ?>
            <?php Pjax::end() ?>

            <script>
                var PersonaForm = new function () {
                    this.init = function () {
                        $(document).on('click', '#newPer', function () {
                            $.get(
                                    $(this).data('url'),
                                    function (data) {
                                        $('.modal-body').html(data);
                                        $('#modal').modal();
                                    }
                            );
                            $(document).on("beforeSubmit", "form#person-form", function (e)
                            {
                                var form = $(this);

                                $.ajax({
                                    url: "/situsYii2/web/index.php?r=person%2Fcreate&submit=true",
                                    data: $("form#person-form").serializeArray(),
                                    method: 'POST',
                                    success: function (result) {
                                        form.parent().html(result.message);
                                        $.pjax.reload({container: "#person-grid"});
                                    },
                                    datatype: 'json'
                                });

                                return false;
                            });
                            $(document).on("submit", "form#person-form", function (e) {
                                e.preventDefault();
                                e.stopImmediatePropagation();
                                return false;
                            });
                        });
                    };
                };

                var updatePer = new function () {
                    this.init = function () {
                        var id;
                        $(document).on('click', '#updPer', function () {
                            id= $(this).data('id');
                            $.get(
                                    $(this).data('url'),
                                    function (data) {
                                        $('.modal-body').html(data);
                                        $('#modal').modal();
                                    }
                            );
                            $(document).on("beforeSubmit", "form#person-form", function (e)
                            {
                                var form = $(this);

                                $.ajax({
                                    url: "/situsYii2/web/index.php?r=person%2Fupdate&id="+id+"&submit=true",
                                    data: $("form#person-form").serializeArray(),
                                    method: 'POST',
                                    success: function (result) {
                                        form.parent().html(result.message);
                                        $.pjax.reload({container: "#person-grid"});
                                    },
                                    datatype: 'json'
                                });

                                return false;
                            });
                            $(document).on("submit", "form#person-form", function (e) {
                                e.preventDefault();
                                e.stopImmediatePropagation();
                                return false;
                            });
                        });
                    };
                };

                var deletePer = new function () {
                    this.init = function () {
                        $(document).on('click', '#delPer', function () {
                            $.ajax({
                                url:  $(this).data('url') + '&id=' + $(this).data('id'),    
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
             
                var viewPer= new function(){
                    this.init= function(){
                    $(document).on('click', '#viewPer', function(){
                
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
            $this->registerJs('PersonaForm.init()');
            $this->registerJs('updatePer.init()');
            $this->registerJs('deletePer.init()');
            $this->registerJs('viewPer.init()');
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
