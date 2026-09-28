import React from 'react';
import { useNavigate } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import Card, { CardContent } from '../components/ui/Card';
import Button from '../components/ui/Button';
import { AlertTriangle, ArrowLeft } from 'lucide-react';

export const NotFoundPage: React.FC = () => {
  const navigate = useNavigate();

  return (
    <PageContainer className="flex items-center justify-center min-h-[70vh]">
      <Card className="max-w-md w-full text-center">
        <CardContent className="p-8 flex flex-col items-center gap-4">
          <div className="p-4 rounded-full bg-amber-50 border border-amber-200 text-amber-600">
            <AlertTriangle className="w-8 h-8" />
          </div>
          <h2 className="text-xl font-bold text-slate-900 tracking-tight">404 — Route Not Found</h2>
          <p className="text-xs text-slate-600 leading-relaxed">
            The requested supervisory path does not exist in the SAT-SA application routing skeleton.
          </p>
          <Button
            variant="secondary"
            icon={<ArrowLeft className="w-4 h-4" />}
            onClick={() => navigate('/')}
            className="mt-2"
          >
            Return to Directory
          </Button>
        </CardContent>
      </Card>
    </PageContainer>
  );
};

export default NotFoundPage;
