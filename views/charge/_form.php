<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Charge */
/* @var $form yii\widgets\ActiveForm */
?>

<div class="charge-form">

    <?php $form = ActiveForm::begin(); ?>

    <?= $form->field($model, 'contract_id')->textInput() ?>

    <?= $form->field($model, 'charge_date')->textInput() ?>

    <?= $form->field($model, 'charge_mount')->textInput() ?>

    <?= $form->field($model, 'charged_period')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'municipality')->textInput() ?>

    <?= $form->field($model, 'water_service')->textInput() ?>

    <?= $form->field($model, 'expenses')->textInput() ?>

    <?= $form->field($model, 'comment')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'expiration')->textInput() ?>

    <?= $form->field($model, 'recharge')->textInput() ?>

    <?= $form->field($model, 'deductions')->textInput() ?>

    <?= $form->field($model, 'other_recharge')->textInput() ?>

    <?= $form->field($model, 'charge_words')->textInput(['maxlength' => true]) ?>

    <div class="form-group">
        <?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>

    <?php ActiveForm::end(); ?>

</div>
