<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;
use yii\jui\DatePicker;

/* @var $this yii\web\View */
/* @var $model app\models\Contract */
/* @var $form yii\widgets\ActiveForm */
?>

<div class="contract-form">

    <?php $form = ActiveForm::begin([
                'id' => 'contract-form',
                'enableAjaxValidation' => true,
                'enableClientScript' => true,
                'enableClientValidation' => true,]); ?>

    
    <?= $form->field($model, 'number')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'extended')->textInput() ?>

    <?= $form->field($model, 'start_date')->widget(DatePicker::className(),[
                'dateFormat' => 'yyyy-MM-dd',
                'clientOptions' => [
                'yearRange' => '-10:+100',
                'changeYear' => true],
                'options' => ['class' => 'form-control']
    ]) ?>

    <?= $form->field($model, 'finish_date')->widget(DatePicker::className(),[
                        'dateFormat' => 'yyyy-MM-dd',
                        'clientOptions' => [
                        'yearRange' => '-10:+100',
                        'changeYear' => true],
                        'options' => ['class' => 'form-control']
    ]) ?>

   

    <?= $form->field($model, 'amount')->textInput() ?>

    <?= $form->field($model, 'status')->dropDownList([ 'finalized' => 'Finalized', 'enabled' => 'Enabled', 'suspended' => 'Suspended', ], ['prompt' => '']) ?>

    <?= $form->field($model, 'commission')->textInput() ?>

    <?= $form->field($model, 'franchise_free')->textInput() ?>

    <?= $form->field($model, 'daily_charge')->textInput() ?>

    <?= $form->field($model, 'duration')->textInput() ?>
    
    <?= $form->field($model, 'property_id')->dropDownList($properties) ?>

    <div class="form-group">
        <?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>

    <?php ActiveForm::end(); ?>

</div>
