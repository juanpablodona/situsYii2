<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Payments';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="payment-index">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('Create Payment', ['create'], ['class' => 'btn btn-success']) ?>
    </p>
    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],

            'payment_id',
            'contract_id',
            'payment_date',
            'payment_mount',
            'payment_period',
            // 'comment',
            // 'deductions',
            // 'recharge',
            // 'charge_id',
            // 'payment_words',

            ['class' => 'yii\grid\ActionColumn'],
        ],
    ]); ?>
</div>
