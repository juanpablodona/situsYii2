<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Contracts';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="contract-index">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('Create Contract', ['create'], ['class' => 'btn btn-success']) ?>
    </p>
    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],

            'contract_id',
            'property_id',
            'number',
            'extended',
            'start_date',
            // 'finish_date',
            // 'amount',
            // 'status',
            // 'commission',
            // 'franchise_free',
            // 'daily_charge',
            // 'duration',

            ['class' => 'yii\grid\ActionColumn'],
        ],
    ]); ?>
</div>
