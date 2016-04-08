<?php

namespace app\controllers;

use app\models\Locality;
use app\models\Person;
use Yii;
use yii\data\ActiveDataProvider;
use yii\filters\VerbFilter;
use yii\helpers\ArrayHelper;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\web\Response;
use yii\widgets\ActiveForm;

/**
 * PersonController implements the CRUD actions for Person model.
 */
class PersonController extends Controller
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
     * Lists all Person models.
     * @return mixed
     */
    public function actionIndex()
    {
        $dataProvider = new ActiveDataProvider([
            'query' => Person::find(),
        ]);

        return $this->render('index', [
            'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single Person model.
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
     * Creates a new Person model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate($submit= FALSE)
    {
        
        $model = new Person();
        
        if (Yii::$app->request->isAjax && $model->load(Yii::$app->request->post()) && $submit== FALSE) {
            Yii::$app->response->format==Response::FORMAT_JSON;
            return json_encode(ActiveForm::validate($model));
        }
        
        if ($model->load(Yii::$app->request->post())) {
            if($model->save()){
                $model->refresh();
                Yii::$app->response->format==Response::FORMAT_JSON;
                return json_encode(['message' => 'Persona creada con exito']);
            } else {
                Yii::$app->response->format==Response::FORMAT_JSON;
                return json_encode(ActiveForm::validate($model));
            }
        }
        
        $localities= ArrayHelper::map(Locality::find()->all(), 'locality_id', 'name');
        
        return $this->renderAjax('create', ['model' => $model, 'localities' => $localities]);
    }

    /**
     * Updates an existing Person model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param integer $id
     * @return mixed
     */
    public function actionUpdate($id, $submit= FALSE)
    {
        $model = $this->findModel($id);

        if (Yii::$app->request->isAjax && $model->load(Yii::$app->request->post()) && $submit == FALSE) {
            Yii::$app->response->format==Response::FORMAT_JSON;
            return json_encode(ActiveForm::validate($model));
        }
        
        if ($model->load(Yii::$app->request->post())) {
            if($model->save()){
                $model->refresh();
                Yii::$app->response->format==Response::FORMAT_JSON;
                return json_encode(['message' => 'Persona actualizada con exito']);
            } else {
                Yii::$app->response->format==Response::FORMAT_JSON;
                return json_encode(ActiveForm::validate($model));
            }
        }
        
        $localities= ArrayHelper::map(Locality::find()->all(), 'locality_id', 'name');
        
        return $this->renderAjax('update', ['model' => $model, 'localities' => $localities]);
    }

    /**
     * Deletes an existing Person model.
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
     * Finds the Person model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param integer $id
     * @return Person the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Person::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
