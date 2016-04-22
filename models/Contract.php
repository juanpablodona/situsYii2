<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "contract".
 *
 * @property integer $contract_id
 * @property integer $property_id
 * @property string $number
 * @property integer $extended
 * @property string $start_date
 * @property string $finish_date
 * @property double $amount
 * @property string $status
 * @property double $commission
 * @property integer $franchise_free
 * @property double $daily_charge
 * @property integer $duration
 *
 * @property Bonification[] $bonifications
 * @property Charge[] $charges
 * @property Property $property
 * @property Payment[] $payments
 * @property PersonContract[] $personContracts
 */
class Contract extends \yii\db\ActiveRecord
{
    
    private $_persons;
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'contract';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['property_id'], 'required'],
            [['property_id', 'extended', 'franchise_free', 'duration'], 'integer'],
            [['start_date', 'finish_date'], 'safe'],
            [['amount', 'commission', 'daily_charge'], 'number'],
            [['status'], 'string'],
            [['number'], 'string', 'max' => 11],
            [['property_id'], 'exist', 'skipOnError' => true, 'targetClass' => Property::className(), 'targetAttribute' => ['property_id' => 'property_id']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'contract_id' => 'Contract ID',
            'property_id' => 'Property ID',
            'number' => 'Number',
            'extended' => 'Extended',
            'start_date' => 'Start Date',
            'finish_date' => 'Finish Date',
            'amount' => 'Amount',
            'status' => 'Status',
            'commission' => 'Commission',
            'franchise_free' => 'Franchise Free',
            'daily_charge' => 'Daily Charge',
            'duration' => 'Duration',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getBonifications()
    {
        return $this->hasMany(Bonification::className(), ['contract_id' => 'contract_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getCharges()
    {
        return $this->hasMany(Charge::className(), ['contract_id' => 'contract_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getProperty()
    {
        return $this->hasOne(Property::className(), ['property_id' => 'property_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getPayments()
    {
        return $this->hasMany(Payment::className(), ['contract_id' => 'contract_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getPersonContracts()
    {
        return $this->hasMany(Contract::className(), ['contract_id' => 'contract_id'])
                ->viaTable('person_contract', ['contract_id'=> 'contract_id']);
    }
    
    public static function setPersonContracts(array $persons){
        
        if (empty($persons)) {
            $this->_persons=[];
        }
        
        $this->_persons= $persons;
        
        $personContract= function (){
            $this->unlinkAll('personContracts', true);
            foreach ($this->_persons as $key => $person){
                
                $p= Person::findOne($person[id]);
                $this->link('personContracts', $p, [
                    'person_id'=> $p->person_id, 
                    'contract_id' => $this->contract_id, 
                    'role'=> $p->role]);
            }
            
            
        };
        $this->on(self::EVENT_AFTER_INSERT, $personContract);
        $this->on(self::EVENT_AFTER_UPDATE, $personContract);
        
    }
    
    public function getTotalMount(){
        $date= date('Y');
        
        
        return $this->amount + (($this->commission*$this->amount)/100);
    }
}
