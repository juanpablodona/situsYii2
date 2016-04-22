<?php

use app\models\Contract;
use yii\helpers\Html;
use yii\helpers\Url;
use yii\jui\DatePicker;
use yii\web\View;
use yii\widgets\ActiveForm;

/* @var $this View */
/* @var $model Contract */
/* @var $form ActiveForm */
?>

<div class="contract-form">

    <?php
    $form = ActiveForm::begin([
                'id' => 'contract-form',
                'enableAjaxValidation' => true,
                'enableClientScript' => true,
                'enableClientValidation' => true,]);
    ?>


    <?= $form->field($model, 'number')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'property_id')->dropDownList($properties)?>
    
    <?php
        if (isset($model->contract_id)) {
            echo $form->field($model, 'extended')->textInput();
        }else{
            $model->extended= 0;
        }
        
    ?>

    <?=
    $form->field($model, 'start_date')->widget(DatePicker::className(), [
        'dateFormat' => 'yyyy-MM-dd',
        'clientOptions' => [
            'yearRange' => '-10:+100',
            'changeYear' => true],
        'options' => ['class' => 'form-control', 'id'=>'startDate']
    ])
    ?>
    <?= $form->field($model, 'duration')->dropDownList(
            ['1'=> '1 Año',  '2'=> '2 Años', '3' => '3 Años', '4'=> '4 Años', '5' => '5 Años'],
            ['id'=> 'duration', 'prompt' => ''] ) ?>
    
    <?= $form->field($model, 'finish_date')->textInput(['id'=> 'endDate']) ?>

    <?= $form->field($model, 'amount')->textInput() ?>

    <?= $form->field($model, 'status')->dropDownList([ 'finalized' => 'Finalizado', 'enabled' => 'Activo', 'suspended' => 'En Gestion Judicial',], ['prompt' => '']) ?>

    <?= $form->field($model, 'commission')->textInput() ?>

    <?= $form->field($model, 'franchise_free')->textInput() ?>

    <?= $form->field($model, 'daily_charge')->textInput() ?>

    




    <div class="form-group">
        <?= Html::submitButton($model->isNewRecord ? 'Siguiente' : 'Siguiente', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>

    <?php ActiveForm::end(); ?>

    <script>
        var ContractFunctions = new function () {
            this.duration;
            this.init = function () {
                
                $(document).on("beforeSubmit", "form#contract-form", function (){
                    beforeSubmit();
                });
                $(document).on("submit", "form#contract-form", function(e){
                    submit(e);
                });
                $(document).on("change", "#duration", function(){
                    setDuration();
                });
            };


            function beforeSubmit() {
                $.ajax({
                    url: '<?= Url::to(['contract/create']) ?>' + '&submit=true',
                    data: $("form#contract-form").serializeArray(),
                    method: 'POST',
                    success: function (result) {
                        if (result.status === '1') {
                            $.ajax({
                                url: '<?= Url::to(['bonification/create']) ?>' + '&duration=' + ContractFunctions.duration + '&contract_id=' + result.contract_id,
                                method: 'POST',
                                success: function (data) {
                                    $('.modal-body').html(data);
                                    $('#modal').modal();
                                }
                            });
                        }

                    },
                    dataType: 'json'
                });

                return false;
            }

            function submit(e) {
                e.preventDefault();
                e.stopImmediatePropagation();
                return false;
            }
            
            function setDuration(){
                ContractFunctions.duration= parseInt($('#duration').val());
                var startDate= $('#startDate').val().split('-');
                var endDate= (parseInt(startDate[0])+ ContractFunctions.duration) + '-' +startDate[1]+ '-' + startDate[2];
                $('#endDate').val(endDate);
            }
            

            

        }
    </script>
    
    <?php $this->registerJs('ContractFunctions.init()');?>

</div>
