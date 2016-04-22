<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "person_contract".
 *
 * @property integer $person_id
 * @property integer $contract_id
 * @property integer $person_contract_id
 * @property string $role
 *
 * @property Contract $contract
 * @property Person $person
 */
class PersonContract extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'person_contract';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['person_id', 'contract_id'], 'required'],
            [['person_id', 'contract_id'], 'integer'],
            [['role'], 'string', 'max' => 45],
            [['contract_id'], 'exist', 'skipOnError' => true, 'targetClass' => Contract::className(), 'targetAttribute' => ['contract_id' => 'contract_id']],
            [['person_id'], 'exist', 'skipOnError' => true, 'targetClass' => Person::className(), 'targetAttribute' => ['person_id' => 'person_id']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'person_id' => 'Person ID',
            'contract_id' => 'Contract ID',
            'person_contract_id' => 'Person Contract ID',
            'role' => 'Role',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getContract()
    {
        return $this->hasOne(Contract::className(), ['contract_id' => 'contract_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getPerson()
    {
        return $this->hasOne(Person::className(), ['person_id' => 'person_id']);
    }
}
