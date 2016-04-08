<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Charges';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="charge-index">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('Create Charge', ['create'], ['class' => 'btn btn-success']) ?>
    </p>
    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],

            'charge_id',
            'contract_id',
            'charge_date',
            'charge_mount',
            'charged_period',
            // 'municipality',
            // 'water_service',
            // 'expenses',
            // 'comment',
            // 'expiration',
            // 'recharge',
            // 'deductions',
            // 'other_recharge',
            // 'charge_words',

            ['class' => 'yii\grid\ActionColumn'],
        ],
    ]); ?>
</div>
