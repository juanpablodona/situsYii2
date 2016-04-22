<?php

namespace app\controllers;

use Yii;
use app\models\Payment;
use yii\data\ActiveDataProvider;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/**
 * PaymentController implements the CRUD actions for Payment model.
 */
class PaymentController extends Controller {

    /**
     * @inheritdoc
     */
    public function behaviors() {
        return [
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'delete' => ['POST'],
                ],
            ],
        ];
    }

    /**
     * Lists all Payment models.
     * @return mixed
     */
    public function actionIndex() {
        $dataProvider = new ActiveDataProvider([
            'query' => Payment::find(),
        ]);

        return $this->render('index', [
                    'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single Payment model.
     * @param integer $id
     * @return mixed
     */
    public function actionView($id) {
        return $this->renderAjax('view', [
                    'model' => $this->findModel($id),
        ]);
    }

    /**
     * Creates a new Payment model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate($charge_id, $submit = FALSE) {
        $model = new Payment();

        if (Yii::$app->request->isAjax && $model->load(Yii::$app->request->post()) && $submit == FALSE) {
            Yii::$app->response->format == \yii\web\Response::FORMAT_JSON;
            return json_encode(\yii\widgets\ActiveForm::validate($model));
        }

        if ($model->load(Yii::$app->request->post())) {
            if ($model->save()) {
                $model->refresh();
                Yii::$app->response->format == \yii\web\Response::FORMAT_JSON;
                return 1;
            } else {
                Yii::$app->response->format == \yii\web\Response::FORMAT_JSON;
                return json_encode(\yii\widgets\ActiveForm::validate($model));
            }
        }
        
        $charge= \app\models\Charge::findOne($charge_id); 
           
        return $this->renderAjax('create', ['model' => $model, 'charge'=> $charge ]);
        
    }

    /**
     * Updates an existing Payment model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param integer $id
     * @return mixed
     */
    public function actionUpdate($id, $submit= FALSE) {
        $model = $this->findModel($id);

        if (Yii::$app->request->isAjax && $model->load(Yii::$app->request->post()) && $submit == FALSE) {
            Yii::$app->response->format == \yii\web\Response::FORMAT_JSON;
            return json_encode(\yii\widgets\ActiveForm::validate($model));
        }

        if ($model->load(Yii::$app->request->post())) {
            if ($model->save()) {
                $model->refresh();
                Yii::$app->response->format == \yii\web\Response::FORMAT_JSON;
                return 1;
            } else {
                Yii::$app->response->format == \yii\web\Response::FORMAT_JSON;
                return json_encode(\yii\widgets\ActiveForm::validate($model));
            }
        }
           
        return $this->renderAjax('update', ['model' => $model,]);
    }

    /**
     * Deletes an existing Payment model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param integer $id
     * @return mixed
     */
    public function actionDelete($id, $ok=FALSE) {
        $model=$this->findModel($id);
        
        if ($ok) {
            $model->delete();
            return TRUE;
        }else{
            return $this->renderAjax('delete', ['model'=> $model]);
        } 
        
    }

    /**
     * Finds the Payment model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param integer $id
     * @return Payment the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id) {
        if (($model = Payment::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }

}
