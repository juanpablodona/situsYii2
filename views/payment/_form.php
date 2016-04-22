<?php

use app\models\Payment;
use yii\helpers\Html;
use yii\jui\DatePicker;
use yii\web\View;
use yii\widgets\ActiveForm;

/* @var $this View */
/* @var $model Payment */
/* @var $form ActiveForm */
?>

<div class="payment-form">
    <?php
    if (!isset($model->payment_id)) {
        $payMount= \app\models\Contract::findOne($charge->contract_id)->amount;
    }  else {
        $payMount= $model->payment_mount;
    }
        
    ?>
    <?php $form = ActiveForm::begin([
                'id' => 'payment-form',
                'enableAjaxValidation' => true,
                'enableClientScript' => true,
                'enableClientValidation' => true,]); ?>

    <?= $form->field($model, 'contract_id')->hiddenInput(['value' => $charge->contract_id]) ?>
    
    <?= $form->field($model, 'charge_id')->hiddenInput(['value' =>$charge->charge_id]) ?>
    
    <?= $form->field($model, 'payment_period')->textInput(['maxlength' => true, 'value'=> $charge->charged_period]) ?>

    <?= $form->field($model, 'payment_date')->widget(DatePicker::className(),[
                'dateFormat' => 'dd-MM-yyyy',
                'clientOptions' => [
                'yearRange' => '-10:+100',
                'changeYear' => true],
                'options' => ['class' => 'form-control'],
                
        ])?>
    
    <?= $form->field($model, 'deductions')->textInput(['id' => 'deductions']) ?>

    <?= $form->field($model, 'recharge')->textInput(['id' => 'recharge']) ?>

    <?= $form->field($model, 'payment_mount')->textInput(['id' => 'payMount', 'value'=> $payMount]) ?>

    <?= $form->field($model, 'comment')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'payment_words')->textInput(['maxlength' => true]) ?>

    <div class="form-group">
        <?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>

    <?php ActiveForm::end(); ?>
    
    <script>
        var Mount= new function(){
            this.mountVal;
            this.init= function(){
                this.mountVal= parseFloat($('#payMount').val());
                $(document).on('change', '#deductions', updateMount);
                $(document).on('change', '#recharge', updateMount);
            }
            
            function updateMount (){
                var deductions= $('#deductions').val();
                var recharge= $('#recharge').val();
                   
                
                if (deductions === '') {
                    deductions= 0;
                }else{
                    deductions = parseFloat(deductions);
                }
                
                if (recharge === '') {
                    recharge= 0;
                }else{
                    recharge = parseFloat(recharge);
                }
                
                alert ('deductions ' +  deductions);
                alert ('recharge ' +  recharge);
                
                var  newMount= Mount.mountVal + recharge - deductions;
                
                $('#payMount').val((newMount));
            }
        };
    </script>
    
    <?php
        $this->registerJs('Mount.init()');
    
    ?>

</div>
