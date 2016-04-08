<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Person */

$this->title = $model->name;
$this->params['breadcrumbs'][] = ['label' => 'People', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="person-view">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('Update', ['update', 'id' => $model->person_id], ['class' => 'btn btn-primary']) ?>
        <?= Html::a('Delete', ['delete', 'id' => $model->person_id], [
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
            'person_id',
            'document_type',
            'document_number',
            'name',
            'first_surname',
            'second_surname',
            'street',
            'street_number',
            'phone',
            'mobile',
            'employee',
            'job_adress',
            'profession',
            'civil_status',
            'salary',
            'commercial_references',
            'bank_references',
            'zip_code',
            'bank',
            'bank_number',
            'bank_holder',
            'bank_branch',
            'locality_id',
            'type',
            'owner',
            'cuit',
        ],
    ]) ?>

</div>
