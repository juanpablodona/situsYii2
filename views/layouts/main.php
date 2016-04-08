<?php

/* @var $this \yii\web\View */
/* @var $content string */

use yii\helpers\Html;
use yii\bootstrap\Nav;
use yii\bootstrap\NavBar;
use yii\widgets\Breadcrumbs;
use app\assets\AppAsset;
use yii\bootstrap\Modal;
use yii\helpers\Url;

AppAsset::register($this);
?>
<?php $this->beginPage() ?>
<!DOCTYPE html>
<html lang="<?= Yii::$app->language ?>">
<head>
    <meta charset="<?= Yii::$app->charset ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?= Html::csrfMetaTags() ?>
    <title><?= Html::encode($this->title) ?></title>
    <style>
        .navbar navbar-default navbar-static-top {
            height: 151px;
        }
    </style>
    <?php $this->head() ?>
</head>
<body>
<?php $this->beginBody() ?>

<div class="wrap">
    <?php
    NavBar::begin([
        'brandLabel' => '<img src="'.Yii::getAlias('@web').'/images/situs.png" alt="logo" width="50%">',
        'brandUrl' => Yii::$app->homeUrl,
        'options' => [
            'class' => 'navbar navbar-default navbar-static-top',
            
        ],
    ]);
    echo Nav::widget([
        'options' => ['class' => 'nav nav-pills'],
        'items' => [
            ['label' => 'Personas', 'url' => ['/person/index']],
            ['label' => 'Propiedades', 'url' => ['/property/index']],
            ['label' => 'Contact', 'url' => ['/site/contact']],
            Yii::$app->user->isGuest ? (
                '<li>'
                    .Html::a('Iniciar Sesion', '#', [
                        'id' => 'loginLink',
                        'class' => 'btn btn-success',
                        'data-toggle' => 'modal',
                        'data-target' => '#modal',
                        'data-url' => Url::to(['login']),
                        'data-pjax' => '0',
                    ])
            ) : (
                '<li>'
                . Html::beginForm(['/site/logout'], 'post')
                . Html::submitButton(
                    'Logout (' . Yii::$app->user->identity->username . ')',
                    ['class' => 'btn btn-link']
                )
                . Html::endForm()
                . '</li>'
            )
        ],
    ]);
    NavBar::end();
    ?>

    <div class="container">
        <?= Breadcrumbs::widget([
            'links' => isset($this->params['breadcrumbs']) ? $this->params['breadcrumbs'] : [],
        ]) ?>
        <?= $content ?>
    </div>
</div>

<footer class="footer">
    <div class="container">
        <p class="pull-left">&copy; My Company <?= date('Y') ?></p>

        <p class="pull-right"><?= Yii::powered() ?></p>
    </div>
</footer>
<?php 
    $this->registerJs(
            
            "$(document).on('click', '#loginLink', (function() {
                    $.get(
                            $(this).data('url'),
                            function (data) {
                                $('.modal-body').html(data);
                                $('.modal-dialog').atrr('class', 'modal fade');
                                
                                $('#modal').modal();
                            }
                        );
            }));"        
    )



?>

<?php
    Modal::begin([
        'id' => 'modal',
        'header' => '<h4 class="modal-title">Inicio de Sesion</h4>',
        'footer' => '',
        'class' => 'col-lg-24'
    ]);
    
    echo "<div class='well'></div>";
 
    Modal::end();
?>    
    

<?php $this->endBody() ?>
</body>
</html>
<?php $this->endPage() ?>
