<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Person */
/* @var $form yii\widgets\ActiveForm */
?>

<div class="person-form">

    <?php
    $form = ActiveForm::begin([
                'id' => 'person-form',
                'enableAjaxValidation' => true,
                'enableClientScript' => true,
                'enableClientValidation' => true,
    ]);
    ?>

    <?= $form->field($model, 'document_type')->dropDownList([ 'DNI' => 'DNI', 'LC' => 'LC', 'LE' => 'LE', 'Ext' => 'Ext',], ['prompt' => '']) ?>

    <?= $form->field($model, 'document_number')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'name')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'first_surname')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'second_surname')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'street')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'street_number')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'phone')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'mobile')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'employee')->textInput() ?>

    <?= $form->field($model, 'job_adress')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'profession')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'civil_status')->dropDownList([ 'single' => 'Single', 'married' => 'Married', 'divorced' => 'Divorced', 'widowed' => 'Widowed',], ['prompt' => '']) ?>

    <?= $form->field($model, 'salary')->textInput() ?>

    <?= $form->field($model, 'commercial_references')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'bank_references')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'zip_code')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'bank')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'bank_number')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'bank_holder')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'bank_branch')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'locality_id')->dropDownList($localities) ?>

    <?= $form->field($model, 'type')->dropDownList([ 'guarantor' => 'Guarantor', 'locator' => 'Locator', 'owner' => 'Owner', 'receiver' => 'Receiver',], ['prompt' => '']) ?>

    <?= $form->field($model, 'owner')->textInput() ?>

        <?= $form->field($model, 'cuit')->textInput(['maxlength' => true]) ?>

    <div class="form-group">
    <?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>

    <?php ActiveForm::end(); ?>
    
</div>
