<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;
use yii\jui\DatePicker;
use yii\web\View;

/* @var $this yii\web\View */
/* @var $model app\models\Charge */
/* @var $form yii\widgets\ActiveForm */
?>

<div class="charge-form">

    <?php $form = ActiveForm::begin([
                'id' => 'charge-form',
                'enableAjaxValidation' => true,
                'enableClientScript' => true,
                'enableClientValidation' => true,]); ?>
    
    <?php 
        
        $contract_id= $contract->contract_id;
                
    ?>

    <?= $form->field($model, 'contract_id')->textInput(['value'=> $contract_id]) ?>

    <?= $form->field($model, 'charge_date')->widget(DatePicker::className(),[
                'dateFormat' => 'dd-MM-yyyy',
                'clientOptions' => [
                'yearRange' => '-10:+100',
                'changeYear' => true],
                'options' => ['class' => 'form-control'],
                
                
    ]) ?>
    
     <?= $form->field($model, 'expiration')->widget(DatePicker::className(),[
                'dateFormat' => 'dd-MM-yyyy',
                'clientOptions' => [
                'yearRange' => '-10:+100',
                'changeYear' => true],
                'options' => ['class' => 'form-control'],
                
                
         ])?>

    <?= $form->field($model, 'charged_period')->textInput(['maxlength' => true]) ?>
    
    <?= $form->field($model, 'deductions')->textInput(['id'=>'deductions']) ?>
    
    <?= $form->field($model, 'recharge')->textInput(['id'=>'recharges']) ?>
    
    <?= $form->field($model, 'other_recharge')->textInput(['id'=>'otherRecharges']) ?>
    
    <?= $form->field($model, 'charge_mount')->textInput(['value' => $contract->getTotalMount(), 'id'=> 'mount']) ?>
    
    <?= $form->field($model, 'charge_words')->textInput(['maxlength' => true]) ?>
    
    <?= $form->field($model, 'municipality')->dropDownList(['-1' => 'No Corresponde', '0' => 'No', '1' => 'Si']) ?>

    <?= $form->field($model, 'water_service')->dropDownList(['-1' => 'No Corresponde', '0' => 'No', '1' => 'Si']) ?>

    <?= $form->field($model, 'expenses')->dropDownList(['-1' => 'No Corresponde', '0' => 'No', '1' => 'Si'])?>

    <?= $form->field($model, 'comment')->textInput(['maxlength' => true]) ?>
    
    
    <div class="form-group">
        <?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>

    <?php ActiveForm::end(); ?>
    
    <script>
         var mount=parseFloat(<?= $contract->getTotalMount()?>);
         var events= new function(){
             this.init= function(){
                $(document).on('change', '#charge-charge_date', calculateRecharge);
                $(document).on('change', '#deductions', updateMount);
                $(document).on('change', '#otherRecharges', updateMount);
             }
         }
        
    
        function calculateRecharge(){
            
            var chargeDate= $('#charge-charge_date').val();
            var date= chargeDate.split('-');
            var day= date[0];
            var franchise= <?=$contract->franchise_free?>;
            var recharge= <?= $contract->daily_charge?>;
            var rechargeDays= parseInt(day) - parseInt(franchise);
            
            if (rechargeDays >= 1) {
                $('#recharges').val((rechargeDays * parseFloat(recharge)).toString());
                updateMount();
            }else{
                $('#recharge').val('0');
            }    
        }
        
        function updateMount(){
            
            var recharge= $('#recharges').val();
            var deductions= $('#deductions').val();
            var other_recharges= $('#otherRecharges').val();
            
            if (recharge !== '') {
                recharge= parseFloat(recharge);
            }else{
                recharge = 0;
            }
            if (deductions !== '') {
                deductions= parseFloat(deductions);
            }else{
                deductions = 0;
            }
            if (other_recharges !== '') {
                other_recharges= parseFloat(other_recharges);
            }else{
                other_recharges = 0;
            }
            
            $('#mount').val((mount + recharge + other_recharges - deductions).toString());
        }    
    
    </script>
    
    <?php $this->registerJs('events.init()');?>

</div>
