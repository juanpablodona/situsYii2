<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\PersonContract */

$this->title = 'Update Person Contract: ' . $model->person_contract_id;
$this->params['breadcrumbs'][] = ['label' => 'Person Contracts', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $model->person_contract_id, 'url' => ['view', 'id' => $model->person_contract_id]];
$this->params['breadcrumbs'][] = 'Update';
?>
<div class="person-contract-update">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
    ]) ?>

</div>
