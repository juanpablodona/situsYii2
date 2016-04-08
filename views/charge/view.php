<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Charge */

$this->title = $model->charge_id;
$this->params['breadcrumbs'][] = ['label' => 'Charges', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="charge-view">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('Update', ['update', 'id' => $model->charge_id], ['class' => 'btn btn-primary']) ?>
        <?= Html::a('Delete', ['delete', 'id' => $model->charge_id], [
            'class' => 'btn btn-danger',
            'data' => [
                'confirm' => 'Are you sure you want to delete this item?',
                'method' => 'post',
            ],
        ]) ?>
    </p>

    <?= DetailView::widget([
        'model' => $model,
        'attributes' => [
            'charge_id',
            'contract_id',
            'charge_date',
            'charge_mount',
            'charged_period',
            'municipality',
            'water_service',
            'expenses',
            'comment',
            'expiration',
            'recharge',
            'deductions',
            'other_recharge',
            'charge_words',
        ],
    ]) ?>

</div>
