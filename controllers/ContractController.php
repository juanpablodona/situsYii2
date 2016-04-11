<?php

namespace app\controllers;

use Yii;
use app\models\Contract;
use yii\data\ActiveDataProvider;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
use yii\helpers\ArrayHelper;
use yii\web\Response;
use yii\widgets\ActiveForm;

/**
 * ContractController implements the CRUD actions for Contract model.
 */
class ContractController extends Controller
{
    /**
     * @inheritdoc
     */
    public function behaviors()
    {
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
     * Lists all Contract models.
     * @return mixed
     */
    public function actionIndex()
    {
        $dataProvider = new ActiveDataProvider([
            'query' => Contract::find(),
        ]);

        return $this->render('index', [
            'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single Contract model.
     * @param integer $id
     * @return mixed
     */
    public function actionView($id)
    {
        return $this->renderAjax('view', [
            'model' => $this->findModel($id),
        ]);
    }

    /**
     * Creates a new Contract model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate($submit= FALSE)
    {
        $model = new Contract();

        if (Yii::$app->request->isAjax && $model->load(Yii::$app->request->post()) && $submit== FALSE) {
            Yii::$app->response->format==Response::FORMAT_JSON;
            return json_encode(ActiveForm::validate($model));
        }
        
        if ($model->load(Yii::$app->request->post())) {
            if($model->save()){
                $model->refresh();
                Yii::$app->response->format==Response::FORMAT_JSON;
                return json_encode(['message' => 'Contrato creado con exito']);
            } else {
                Yii::$app->response->format==Response::FORMAT_JSON;
                return json_encode(ActiveForm::validate($model));
            }
        }
        
        $properties= ArrayHelper::map(\app\models\Property::find()->all(), 'property_id', 'name');
        
        return $this->renderAjax('create', ['model' => $model, 'properties' => $properties]);
    }

    /**
     * Updates an existing Contract model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param integer $id
     * @return mixed
     */
    public function actionUpdate($id, $submit=FALSE)
    {
        $model = $this->findModel($id);

        if (Yii::$app->request->isAjax && $model->load(Yii::$app->request->post()) && $submit== FALSE) {
            Yii::$app->response->format==Response::FORMAT_JSON;
            return json_encode(ActiveForm::validate($model));
        }
        
        if ($model->load(Yii::$app->request->post())) {
            if($model->save()){
                $model->refresh();
                Yii::$app->response->format==Response::FORMAT_JSON;
                return json_encode(['message' => 'Contrato actualizado con exito']);
            } else {
                Yii::$app->response->format==Response::FORMAT_JSON;
                return json_encode(ActiveForm::validate($model));
            }
        }
        
        $properties= ArrayHelper::map(\app\models\Property::find()->all(), 'property_id', 'name');
        
        return $this->renderAjax('update', ['model' => $model, 'properties' => $properties]);
    }

    /**
     * Deletes an existing Contract model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param integer $id
     * @return mixed
     */
    public function actionDelete($id, $ok= FALSE)
    {
       $model=$this->findModel($id);
        if ($ok) {
            $model->delete();
            return $this->redirect(['index']);
        }
        
        return $this->renderAjax('delete', ['model' =>$model] );
    }

    /**
     * Finds the Contract model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param integer $id
     * @return Contract the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Contract::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
