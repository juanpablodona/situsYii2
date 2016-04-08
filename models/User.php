<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "user".
 *
 * @property integer $user_id
 * @property string $name
 * @property string $surname
 * @property string $username
 * @property string $password
 * @property string $status
 * @property integer $role_id
 *
 * @property Role $role
 */
class User extends \yii\db\ActiveRecord implements \yii\web\IdentityInterface

{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'user';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['name', 'username', 'password', 'role_id'], 'required'],
            [['status'], 'string'],
            [['role_id'], 'integer'],
            [['name', 'surname', 'username', 'password'], 'string', 'max' => 45],
            [['role_id'], 'exist', 'skipOnError' => true, 'targetClass' => Role::className(), 'targetAttribute' => ['role_id' => 'role_id']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'user_id' => 'User ID',
            'name' => 'Name',
            'surname' => 'Surname',
            'username' => 'Username',
            'password' => 'Password',
            'status' => 'Status',
            'role_id' => 'Role ID',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getRole()
    {
        return $this->hasOne(Role::className(), ['role_id' => 'role_id']);
    }
    
   
    public function getAuthKey() {
        
    }

    public function getId() {
        
    }

    public function validatePassword($pass) {
        if ($this->password == $pass) {
            return TRUE;
        }else{
            return FALSE;
        }
    }

    public static function findIdentity($id) {
        
    }

    public static function findIdentityByAccessToken($token, $type = null) {
        
    }

    public function validateAuthKey($authKey) {
        
    }

}
